module ReadTimeHelper
  WORDS_PER_MINUTE = 180

  # Over estimate time by splitting on spaces (may include non-words, i.e., markup tags)
  def text_read_time(input)
    words = input.split.count
    minutes = (words / WORDS_PER_MINUTE).floor
    minutes_label = (minutes == 1) ? ' minute' : ' minutes'
    minutes > 0 ? "#{minutes} #{minutes_label}" : '< 1 minute'
  end

  # Better estimate of time by removing code blocks
  def markdown_file_read_time(source_file)
    ignored_blocks = /(?: ^```.+?^```$)/mx

    text_read_time(File.new(source_file).read.split(/^---$/)[-1].gsub(ignored_blocks, ''))
  end
end
