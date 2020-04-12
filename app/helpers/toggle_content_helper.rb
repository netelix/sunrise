module ToggleContentHelper
  def toggle_button_show(
    toggler_class, content_visible = true, label = nil, show_icon = true, &block
  )
    html_class = {
      'data-target' => ".#{toggler_class}",
      'data-toggle' => 'collapse',
      'class' => "#{toggler_class} show-button collapse #{'show' unless content_visible}"
    }

    if block_given?
      link_to '', html_class, &block
    else
      link_to '', html_class do
        raw [
              content_tag('span', label, class: 'd-none d-sm-inline'),
              (fa_icon('angle-down') if show_icon)
            ].compact.join(' ')
      end
    end
  end

  def toggle_button_hide(
    toggler_class, content_visible = true, label = nil, show_icon = true, &block
  )
    html_class = {
      'data-target' => ".#{toggler_class}",
      'data-toggle' => 'collapse',
      'class' => "#{toggler_class} hide-button collapse #{'show' if content_visible}"
    }

    if block_given?
      link_to '', html_class, &block
    else
      link_to '', html_class do
        raw [
              content_tag('span', label, class: 'd-none d-sm-inline'),
              (fa_icon('angle-up') if show_icon)
            ].compact.join(' ')
      end
    end
  end

  def toggle_content(toggler_class, content_visible = true, &block)
    content_tag 'div',
                class: "#{toggler_class} collapse #{'show' if content_visible}",
                &block
  end
end
