module Sunrise
  module ApplicationHelper
    def app_name
      Rails.application.config.app_name
    end

    def deferred_image_tag(src, options = {})
      return '' if src.blank?

      resolved_src =
          begin
            image_path(src)
          rescue Sprockets::Rails::Helper::AssetNotFound
            src
          end

      image_tag(
          'data:image/png;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs=',
          options.merge!(data: { src: resolved_src })
      )
    end

    def button_to_delete(content, path, options = {})
      button_to path, delete_params.merge(options) do
        content
      end
    end

    def delete_params
      {
          method: :delete,
          remote: true,
          form: { 'data-modal': true },
          data: { confirm: t('shared.confirm_delete_message') }
      }
    end

    def content_for_metas(contents)
      contents.each{ |key, value| content_for(key, value) }
    end
  end
end