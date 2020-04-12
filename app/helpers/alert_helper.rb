module AlertHelper
  def alert_info(content, options = {})
    content_tag(
      :div,
      content,
      options.merge(class: "alert alert-info #{options[:class]}", role: 'alert')
    )
  end
end
