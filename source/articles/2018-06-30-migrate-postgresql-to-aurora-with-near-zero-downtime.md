---
title: "Migrating PostgreSQL to Aurora with near Zero-Downtime"

description: "The goal here is to migrate an Amazon Web Services Relational Database Service PostgreSQL Database to Aurora with as little downtime as possible. The following documents the initial strategy that was considered using read replica promotion, followed by the end result using AWS's Database Migration Service."

tags:
- database
- postgresql
- aurora
- aws

originally_posted_to: "https://techblog.thescore.com/2018/06/29/migrating-postgresql-to-aurora-with-near-zero-downtime/"

pull_image: "/images/2018-06-30-migrate-postgresql-to-aurora-with-near-zero-downtime/elephant-migration.jpg"
pull_image_attribution: '[15_CBP_JMP-39](https://flickr.com/photos/jeaneeem/22658750486 "15_CBP_JMP-39") by [jeaneeem](https://flickr.com/people/jeaneeem) is licensed under [CC BY-NC-ND](https://creativecommons.org/licenses/by-nc-nd/2.0/)'
---

The goal here is to migrate an Amazon Web Services (AWS) Relational Database Service (RDS) PostgreSQL Database to Aurora with as little downtime as possible. The following documents the initial strategy that was considered using read replica promotion, followed by the end result using AWS's Database Migration Service (DMS).

# Why Aurora

From the [Aurora Details Page](https://aws.amazon.com/rds/aurora/details/):

> Amazon Aurora is designed to offer greater than 99.99% availability, increasing MySQL and PostgreSQL performance and availability by tightly integrating the database engine with an SSD-backed virtualized storage layer purpose-built for database workloads. Amazon Aurora's storage is fault-tolerant and self-healing and disk failures are repaired in the background without loss of database availability. Amazon Aurora is designed to automatically detect database crashes and restart without the need for crash recovery or to rebuild the database cache. If the entire instance fails, Amazon Aurora will automatically fail over to one of up to 15 read replicas.

Essentially, better performance, reliability, and the ability to scale.

Our configuration changes become easier. Aurora acts as a cluster, so we have two endpoints to deal with, and the replicas underneath will adjust dynamically. We use [Makara](https://github.com/taskrabbit/makara) to spread our database queries between our master and slaves. With RDS PostgreSQL we would have to enumerate all our slave databases so we could take advantage of the replicas. If we added a new replica, we would have to adjust our configuration to take advantage of it. With Aurora, we have two endpoints to deal with now (primary/writer and a read-only URL). These endpoints will dynamically rotate between the available instances that fall under that cluster URL. This is great as it handles a failover to a different primary database, or changing the number of replicas. Effectively, we end up with less configuration, but we still need Makara to direct our write and read queries to the two cluster URLs.

# Migration Approaches

As mentioned earlier, there are two approaches to doing this migration. First, we'll cover the _recommended_ approach that AWS suggested as we're on the RDS platform. As we'll cover, it is easy and quick but it does incur downtime during the migration. The second approach uses DMS and was brought up to us after opening a support ticket with AWS on how to do our migration with zero downtime.

## Read Replica Promotion

This is the _recommended_ approach for migrating from PostgreSQL to Aurora. It is easy and has a little risk (during the migration), although it has unavoidable downtime.

* Create an Aurora read replica off of your master database.
* Pause the master PostgreSQL database.
  * This is done so that the no additional write changes are occurring (as it won't be replicated to the Aurora read replica during the promotion process).
* Promote the Aurora read replica.
  * This takes about 10-20 minutes (at least in our experience).
* Deploy app configuration changes to use new Aurora cluster for write/reads.
* Immediately start building additional read replicas to match existing number.
  * Each one takes about 5-10 minutes to create (at least in our experience).
* When happy with the new setup, remove/delete the old databases.

It is _recommended_ to do a dry run of the promotion (and just throw it away afterwards) to gauge how long that process takes.

The issue here is that you have:

* Downtime due to the promotion process. You need to prevent writes from happening on the master. Replication between the PostgreSQL master and the Aurora read replica breaks when the promotion process starts.
* Immediately after you have your new Aurora master, you need to start building read replicas up.
  * In our case, we would want to match our existing number of replicas. So this would take additional time. Otherwise, you possibly run the risk of overwhelming the Database without those read replicas up.

One good thing is that even with the downtime the old read replicas will continue to serve up `GET` requests. In addition, any CDN/[Varnish](https://varnish-cache.org/) caching will also help serve stale data during the downtime.

## Full Load and Ongoing Replication with DMS

This approach is much more involved and finicky, but it does offer a _near_ zero-downtime migration strategy. The general process here is:

* Create an Aurora read replica (this is so we can keep the DB schema)
* Promote Aurora read replica so it is on its own
* Tweak settings on PostgreSQL DB
* Setup DMS Endpoints for the original PostgreSQL and Aurora databases
* Setup DMS Replication Instance to assist in the migration
* Setup DMS Task to use the endpoints and the replication instance
* Truncate Aurora data (we want to wipe the data, but we keep the schema)
* Initiate the migration
  * The first phase is a _full load_ of the tables from the source to the target
  * The second phase is an _on-going replication_ of changes from the source to the target
* Both DBs are in-sync now
* Create read replicas off of the Aurora master
* Change app configuration to point to Aurora cluster
* Delete old DBs

This is a multi-part process, so the following sections will walk through each part.

### Setting up Aurora Read Replica

* Create an Aurora read replica of the PostgreSQL database
  * Name it something like `<service>—<environment>-aurora`
* By creating an Aurora instance, we also get an Aurora cluster (i.e., `<service>—<environment>-aurora-cluster`)
  * Ensure the subnet group and the security groups are set to the same values as defined for the PostgreSQL DB.
* You don't need to have multi-AZ here, Aurora will handle fast failover if we have a replica
* Additional read replicas can then be added later using `<service>—<environment>-aurora-<##>`

At this point, we will have an Aurora read replica that is receiving replicated data changes off the master.

### Aurora Read Replica Promotion

To isolate our newly created Aurora read replica so it can be its own master, we're going to promote the replica. This process allows the instance to receive writes, and be the master for other replicas. We need to do this as otherwise we are limited to only one Aurora read replica off of a PostgreSQL master database. By starting the promotion process the on-going replication is broken between the PostgreSQL and Aurora databases.

### Tweak the Database Parameters

To enable the ability for PostgreSQL to replicate to Aurora we need to make sure we have certain database parameters set.

#### Configure PostgreSQL for Replication

The first thing you need to do is change the `rds.logical_replication` parameter to 1. As described in [the documentation](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.PostgreSQL.html#CHAP_Source.PostgreSQL.RDSPostgreSQL) this parameter actually configures additional related parameters that allow the replication to process:

> As part of applying this parameter, AWS DMS sets the `wal_level`, `max_wal_senders`, `max_replication_slots`, and `max_connections` parameters.

Another parameter configuration that [Amazon recommends](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.PostgreSQL.html#CHAP_Source.PostgreSQL.Prerequisites) is to set `wal_sender_timeout` to 0.

> The `wal_sender_timeout` parameter terminates replication connections that are inactive longer than the specified number of milliseconds. Although the default is 60 seconds, we recommend that you set this parameter to zero, which disables the timeout mechanism.

Without setting the timeout parameter, the streaming of Write-Ahead Logging (WAL) files can be terminated if the sender is under load and does not send a WAL file within the timeout period. To prevent any risk of this it is best to disable it during the on-going replication phase of the migration process.

There are additional `wal` settings available, but we _shouldn't_ need to configure them.

#### Configure Aurora for Replication

On the Aurora instance, we want to limit any foreign key constraints from triggering as the full loads for tables are occurring. Fortunately, if we change the `session_replication_role` parameter to `replica`, it only keeps _replica_ related constraint triggers active. This effectively disables foreign key constraints for us.

### Create Replication Instance

DMS uses a dedicated _replication instance_ to help facilitate the migration process. In a PostgreSQL to Aurora migration, this machine is responsible for connecting to both the source and target databases and transforming and transferring the data.

The following steps expand on what is needed to set up a replication instance for the migration.

* Create a replication instance under DMS
  * Name it as specific as possible for its purpose (i.e., production-api-replication-instance)
  * The _Instance Size_ might need to be tweaked based on various factors ([documentation on instance sizes](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReplicationInstance.html#CHAP_ReplicationInstance.InDepth))
    * For example, in our staging we used `dms.t2.large`, while for production we used `dms.c4.large`
  * Set the _VPC_ to the same as the source and target databases
  * Enable _Multi-AZ_ as it is needed for on-going replication
  * The instance doesn’t need to be _Publicly Accessible_ (as the internal connections are done within the VPC)
  * Ensure the _VPC Security Group_ under _Advance_ is set to `default`
    * This allows for connections between the databases and the replication instance

### Create Source and Target Endpoints

We need to define the _endpoints_ of our databases in DMS. One to represent the source database (PostgreSQL) and another to represent the target database (Aurora). The following steps are to be applied to each endpoint.

* The _Server Name_ is the DB’s endpoint (i.e., the connection URL)
  * You cannot use a read replica as your source (it does not support on-going replication)
* The _User_ and _Password_ are for the master user account of the database
  * The account _needs_ to be the master account. Otherwise, you need to follow the additional instructions listed in the [documentation](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.PostgreSQL.html#CHAP_Source.PostgreSQL.RDSPostgreSQL)
  * The _Password_ cannot have certain characters (`: ; + %`)
* Test the endpoint
  * After a success ensure you refresh the schema

### Create Task

The DMS _task_ is where we actually configure and use the _endpoints_ and _replication instance_ to accomplish the migration. There are a couple of options and considerations to be made while creating a task. The following steps outline how to create a task, and the settings to configure:

* Use the _source and target endpoints_ along with the _replica instance_ that was created for this migration task
* Set the _Migration type_ to `Migrate existing data and replicate ongoing changes`
  * This ensures that we are doing the 2 phase approach:
    * Doing a full-load of the table's data
    * Doing on-going replication of changes on the source database
* _Target table preparation mode_ should be `Do nothing`
  * The reason here is that we want to preserve the table's metadata (i.e., indexes, defaults, constraints)
    * `Truncate` could work, but is likely to fail due to constraints in the database
  * Remember that by using `Do nothing` the target database needs to be truncated manually prior to running the task
* _Stop task after full load completes_ should be set to `Don't stop`.
  * This ensures the on-going replication process starts immediately when a table is fully loaded
* For the table mappings, we want to migrate all tables (i.e., `where schema name is like 'public' and table name is like '%', include`)
* It is useful to enable the _validation_ and _logging_ to see how things are progressing during the migration

_Include LOB columns in replication_ is an interesting setting, LOBs are _Large Objects_ that exist during the migration. As DMS is possibly migrating to a different database type a transformation of data types occurs. To understand what we're dealing with you need to look up the source database's supported types in the documentation. For example, using the DMS documentation you can see what [PostgreSQL data types](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.PostgreSQL.html#CHAP_Source.PostgreSQL.DataTypes) end up being LOBs.

The following section will dig a little deeper into LOBs and the considerations that need to be considered.

#### Full or Limited LOB Mode

There are two options for handling LOBs during the migration: _Full_ or _Limited_ LOB Mode. LOBs are potentially massive objects that reside in the database, and they normally don't have a fixed size in the column. The following [documentation](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.LOBSupport.html) describes the two options:

DMS provides you with the _Full LOB Mode_:

> In full LOB mode, AWS DMS migrates all LOBs from source to target regardless of size. In this configuration, AWS DMS has no information about the maximum size of LOBs to expect. Thus, LOBs are migrated one at a time, piece by piece. Full LOB mode can be quite slow.

DMS also provides the _Limited LOB Mode_:

> In limited LOB mode, you set a maximum size LOB that AWS DMS should accept. Doing so allows AWS DMS to pre-allocate memory and load the LOB data in bulk. LOBs that exceed the maximum LOB size are truncated and a warning is issued to the log file. In limited LOB mode, you get significant performance gains over full LOB mode. We recommend that you use limited LOB mode whenever possible.

Initially, it makes sense to just use _Full LOB Mode_ as it'll preserve data by migrating LOBs regardless of size. The big issue with this choice is _speed_. In our migration, we achieve full migration in 2 hours using _Limited LOB Mode_ and we estimated about 90 hours using _Full LOB Mode_. The issue with using _Limited LOB Mode_ is that you can essentially lose data if the LOB's size is less than the `Max LOB Size` parameter.

To work around this concern, the plan is to determine the max LOB size in the database and set the `Max LOB Size` to slightly bigger than that value (i.e., multiply it by 2). By using a larger `Max LOB Size` than the largest LOB we have in the database, we are ensured to have the full data migrated without any data loss.

A manual way to check for the size of a LOB column is to use the following query: `SELECT max(pg_column_size(column_name)) FROM table_name;`. This will return the max number of bytes used in that column. This is the value you'll want to be larger than. The following is a Rails rake task that walks through every table's column and identifies the max sizes for any LOB column (for PostgreSQL):

```ruby
namespace :scripts do
  desc 'Print out the max size of LOBs in the database. Usage: bin/rake scripts:max_lob_size'
  task max_lob_size: :environment do
    output = {}

    LOB_TYPES = %w(
      hstore
      composite
      array
      jsonb
      json
      polygon
      path
      xml
      tsquery
      tsvector
      bytea
      text
    ).freeze

    ActiveRecord::Base.connection.tables.each do |table_name|
      next if table_name == 'schema_migrations' || table_name.starts_with?('awsdms_')

      columns_sql = <<~HEREDOC
        SELECT *
        FROM information_schema.columns
        WHERE table_schema = 'public'
          AND table_name   = '#{table_name}'
      HEREDOC

      columns_results = ActiveRecord::Base.connection.execute(columns_sql)

      columns_results.each do |row|
        column_name = row['column_name']
        column_type = row['data_type']

        if LOB_TYPES.include?(column_type)
          size_sql = <<~HEREDOC
            SELECT max(pg_column_size(#{column_name})) FROM #{table_name};
          HEREDOC
          size_results = ActiveRecord::Base.connection.execute(size_sql)

          table_hash = output[table_name.to_sym] = {}
          column_hash = table_hash[column_name.to_sym] = {}

          column_hash[:column_type] = column_type
          column_hash[:max_bytes_size] = size_results[0]['max'].to_i
        end

        print '.'
      end
    end

    puts "\nRaw Dump"
    pp output

    max_bytes = output.values.map { |x| x.values.first[:max_bytes_size] }.compact.max
    puts "Max bytes found in a LOB column is #{max_bytes}"
  end
end
```

#### LOB Nullability Constraints

There are some concerns with `NOT NULL` database constraints on columns that become LOBs during the migration. DMS has a certain process for dealing with tables with LOBs:

* The data for each column in a row is added, except for LOB columns
* LOB columns are left with a `null` placeholder
* Afterwards, LOB data replaces the `null` placeholders

This two-step process of dealing with LOB data types is where we have to be concerned with `NOT NULL` constraints. The migration will fail if any LOB columns have a `NOT NULL` constraint. In PostgreSQL, a common case of LOBs is `jsonb` and `array` columns. So we have to _remove_ these constraints on the target database just until the full table load phase is done. For example, the following statement would do the trick, `ALTER TABLE my_table ALTER COLUMN lob_column DROP NOT NULL;`. Do not forget to add the `NOT NULL` constraints back after the full table load phase is done.

### Migration Time

At this point, the migration process is pretty much ready! Let's break the process up into before/during/after migration.

#### Before Migration

Make sure that the:

* The DMS endpoints, task and replication instance are present and configured
* The Aurora instance is ready:
  * Truncated data
  * Disabled LOB nullability constraints

One thing that is suggested is to run `Assess` on the task so you can get a report of potential issues. In our case, there were a couple of _Partially supported datatypes : float8_ on a few columns. This ended up changing the rounding of floats (i.e., 1.4999999998 --> 1.5). It is worth noting that these differences occur after the migration process is completed and changes are being done on the new database type.

For the migration, ideally, it is done during a _low_ activity period. In addition, if possible stop any background jobs just before the migration, and wait for the current jobs to finish. The jobs can resume processing after the migration, this is to reduce risk.

#### During Migration

* Keep an eye on the source database's health
  * There will be additional load placed on it during the migration
    * If needed you could always lower the number of tables loaded in parallel during the _full load_ phase (under the advanced settings in the _Task_)
* Monitor the task's _Table Statistics_ tab to make sure tables are progressing well
* Monitor the task's _Task Monitoring_ tab to make sure the on-going replication is keeping up
  * The `CDCIncomingChanges` should be as close to 0 as possible
  * During the _full load_ phase, the `CDCIncomingChanges` will climb as the on-going replication changes are stored until the tables have fully loaded into the target database
* Monitor the replication instance's _Monitoring_ tab to make sure the `FreeStorageSpace` and `FreeableMemory` are not dropping too low
  * If any of these are too low then the migration can fail

The first phase is _full table load_, where all the source data is dumped into the target. Be aware that large tables can take some time. After a table has been fully loaded into the target, the on-going replication phase starts for that table.

The _on-going replication_ phase is where _inserts/deletes/updates_ are replicated from the source to the target. After all the tables are in this phase (all tables in a _Table Completed_ state), it is now safe to re-enable the LOB nullability constraints that were disabled earlier.

##### Validations

If you have validations enabled for the _Task_ then the _validation_ columns in the _Table Statistics_ will update during the migration. These validations put additional load on the source and target database as the row data is compared after that row has been migrated. It is an on-going validation process.

Personally, I found the validation to be very flaky. It is either _really slow_ and it also reports validation errors that are not actual errors. In our case, we didn't pay much attention to the validation failures as spot checking proved that the data was _fine_. There were _minor_ cases where time columns were _slightly off_. I am unsure how the validation actually works (i.e., when it does the checks), as the on-going replication could be lagging behind. According to the [documentation](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Validating.html#CHAP_Validating.Limitations), there are some limitations that might prevent it from being that useful:

* If one or more rows are being continuously modified during the validation, then AWS DMS can't validate those rows. However, you can validate those _busy_ rows manually, after the task completes.
* If AWS DMS detects more than 10,000 failed or suspended records, it will stop the validation. Before you proceed further, resolve any underlying problems with the data.

In either case under the target's database, there is a new table called `awsdms_validation_failures_v1` that contains information on the failures. The `KEY` and `TABLE_NAME` columns can be used to identify the record in question. It is then possible to check the source and target record and see if there are any issues. One other problem we had with spot-checking validation is that our PostgreSQL database used `UUID`s for primary keys, this resulted in the `KEY` column having truncated data on the `UUID`.

#### After Migration

Hopefully, the migration went successfully, and both the source and target database are in-sync. At this point, the zero-downtime migration can occur -- simply point the application at the new database. It is advisable to wait for any replication lag or queued up `CDCIncomingChanges` to drain before proceeding. You might have to wait a little bit for the connections of your application to cycle over to the new database, but you can monitor this in CloudWatch, or force the cycle (i.e., restart Rails Unicorn servers). Don't forget to resume any background queues. After sufficient time, you can decommission the old database resources.

In the event that the migration doesn't go as planned, it is possible to revert back to the old database. The only issue is that any write data that occurred during the migration process (i.e., only on the Aurora database) wouldn't be present on the old database (i.e., PostgreSQL database). This is simply an issue that cannot be worked around, and hopefully, the low activity period reduces the amount of data loss.
