module MetaHelpers
  def current_type
    if @current_tag
      :tag
    elsif @current_date
      :calendar
    elsif current_article
      :article
    else
      :page
    end
  end

  def page_title
    separator = ' — '
    title = ''

    case current_type
    when :tag
      title += @current_tag + separator
    when :calendar
      title += @current_date + separator
    else
      title += current_page.data.title + separator if current_page.data.title
    end

    title << 'Kevin Jalbert'
  end

  def page_description
    case current_type
    when :tag
      "Posts by Kevin Jalbert about #{@current_tag}."
    when :calendar
      "Archive for #{@current_date}."
    else
      current_page.data.description if current_page.data.description
    end
  end
end
