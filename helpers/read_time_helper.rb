module ReadTimeHelper
  WORDS_PER_MINUTE = 180
  MINUTE_READ_LABEL = ' min read'.freeze

  # Over estimate time by splitting on spaces (may include non-words, i.e., markup tags)
  def text_read_time(input)
    words = input.split.count
    minutes = (words / WORDS_PER_MINUTE).floor
    minutes > 0 ? "#{minutes} #{MINUTE_READ_LABEL}" : "< 1 #{MINUTE_READ_LABEL}"
  end

  # Better estimate of time by removing code blocks
  def markdown_file_read_time(source_file)
    ignored_blocks = /(?: ^```.+?^```$)/mx

    text_read_time(File.new(source_file).read.split(/^---$/)[-1].gsub(ignored_blocks, ''))
  end
end
