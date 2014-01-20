module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  # Go Back link
  def go_back
    link_to '<i class="icon-arrow-left"></i> Go Back'.html_safe, :back
  end

  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end

end
