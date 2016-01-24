module MarkdownHelper
  def markdown(content)
    Tilt::RedcarpetTemplate.new { content }.render
  end
end
