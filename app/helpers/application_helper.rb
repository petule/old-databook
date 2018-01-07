module ApplicationHelper
  def default_title
    # TODO - doplnit
  end

  def default_description
    # TODO - doplnit
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat alert(msg_type, message)
    end
    nil
  end

  def alert(type, message, can_be_closed = true)
    content_tag(:div, message, class: "alert #{bootstrap_class_for(type)} alert-dismissible", role: 'alert') do
      concat(content_tag(:button, class: 'close', data: { dismiss: 'alert' }) do
        concat content_tag(:span, '&times;'.html_safe, 'aria-hidden' => true)
        concat content_tag(:span, 'Close', class: 'sr-only')
      end) if can_be_closed
      concat message
    end
  end

  def bootstrap_class_for(flash_type)
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def current_if_at(path,trida)
    if current_page?(path)
      "#{trida}"
    end
  end

  def class_if_at(place, article_name = nil)
    'active' if current_page?(place) && (article_name.nil? || (article_name == @article.slug))
  end

  def obj_url obj
    case obj.class.to_s
      when 'Category'
        category_url(obj)
      #when 'Page'
      #  page_url obj
      #when 'SearchPage'
      #  search_details_path
      #when 'RequestPage'
      #  request_path
    end
  end

  def category_url(category)
    categorie_path(category.id)
  end
end
