module Sunrise
  module NameHelper
    def link_to_name_modal(nameable, name = nil, options = nil, html_options = nil, &block)
      return if cannot? :edit, nameable

      html_options, options, name = options, name, block if block_given?
      options ||= {}

      html_options = convert_options_to_data_attributes(options, html_options)
      html_options['data-modal'] = true
      url = nameable.edit_name_path
      html_options['href'.freeze] ||= url

      content_tag('a'.freeze, name || url, html_options, &block)
    end
  end
end
