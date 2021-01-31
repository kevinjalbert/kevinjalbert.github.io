module TagGroupsHelper
  def tag_groups(articles)
    tags = Hash.new(0)

    articles.each do |article|
      article.tags.each { |tag| tags[tag] += 1 }
    end

    tags.sort_by{ |tag| -tag.last }.to_h
  end
end
