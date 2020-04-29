module Sunrise
  module AdminHelper
    def filter_input(target, options = {})
      options =
        {
          class: 'form-control dynamic-filter',
          autocomplete: 'off',
          name: 'filter',
          value: params[:query],
          'data-result-container' => 'tbody',
          'data-target' => target
        }.merge(options)
      content_tag(:input, nil, options)
    end
  end
end
