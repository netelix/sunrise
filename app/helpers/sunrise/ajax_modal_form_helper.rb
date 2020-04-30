module Sunrise
  module AjaxModalFormHelper
    def ajax_modal_form(
      error_message: error_message = t('shared.error_message'),
      notice_message: notice_message = t('shared.notice_message'),
      show_submit: show_submit = true
    )
      bootstrap_form_with(modal_form_params) do |form|
        form_content = capture { yield(form) }

        if mutation_form.success?
          content_tag(
            :div,
            notice_message,
            class: 'alert alert-success',
            role: 'alert',
            'data-ajax-modal-reload-on-success' => '1000'
          )
        else
          [
            form.alert_message(error_message, error_summary: false).to_s,
            form_content,
            (render('shared/forms/ajax_modal_submit', form: form) if show_submit)
          ].compact
            .join
            .html_safe
        end
      end
    end

    def ajax_modal_form_attributes_checkboxes(
      form, type, group_class: group_class = 'column-2'
    )
      form_field = "#{type.to_s}_ids".to_sym
      checked =
        params.dig(resource, form_field)&.map(&:to_i) ||
          mutation_form.form.send(form_field)

      form.collection_check_boxes form_field,
                                  Attr.where(type: type),
                                  :id,
                                  :name,
                                  hide_label: true,
                                  checked: checked,
                                  wrapper_class: "d-flex flex-wrap #{group_class}"
    end

    def ajax_modal_form_attributes_radios(
      form, type, group_class: group_class = 'column-2'
    )
      form_field = "#{type.to_s}_id".to_sym

      form.collection_radio_buttons form_field,
                                    Attr.where(type: type),
                                    :id,
                                    :name,
                                    hide_label: true,
                                    wrapper_class:
                                      "d-flex flex-wrap #{group_class}"
    end

    def modal_alert_success(message)
      content_tag(
        :div,
        message,
        class: 'alert alert-success',
        role: 'alert',
        'data-ajax-modal-reload-on-success' => '1000'
      )
    end

    def link_to_modal(name = nil, options = nil, html_options = nil, &block)
      html_options, options, name = options, name, block if block_given?
      options ||= {}

      html_options = convert_options_to_data_attributes(options, html_options)
      html_options['data-modal'] = true
      url = url_for(options)
      html_options['href'.freeze] ||= url

      content_tag('a'.freeze, name || url, html_options, &block)
    end
  end
end
