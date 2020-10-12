require 'mutation'
module Sunrise
  module Mutations
    class ProcessForm < ::Mutations::Command
      include MutationFormSaveHelpers
      include MutationFormValidateHelpers

      class << self
        attr_reader :form_scope
        define_method("scope") do |v|
          @form_scope = v
        end
      end

      def run
        form.attributes = inputs
        add_errors_to_form

        super
      end

      def add_errors_to_form
        return unless has_errors?

        @errors.each do |field, error|
          if error.symbolic == :custom
            form.errors.add(field, error.message)
          else
            form.errors.add(field, error.symbolic)
          end
        end
      end

      def initialize_form
        raise 'This method must be overriden'
      end

      def process_form(*args)
        reinitialize(args.first)

        outcome = run
        @success = outcome.success?

        outcome
      end

      def process_with_params(params)
        process_form(params.require(self.class.form_scope).permit(permitted_params))
      end

      def form_params(url)
        {
          model: form,
          scope: self.class.form_scope,
          remote: false,
          local: true,
          url: url,
          method: :post,
          html: { id: self.class.to_s.underscore.gsub('/', '-').gsub('_', '-') }
        }
      end

      def success?
        @success == true
      end

      def reinitialize(*args)
        @raw_inputs =
          args.inject({}.with_indifferent_access) do |h, arg|
            unless arg.respond_to?(:to_hash)
              raise ArgumentError.new('All arguments must be hashes')
            end
            h.merge!(arg)
          end

        # Do field-level validation / filtering:
        @inputs, @errors = self.input_filters.filter(@raw_inputs)

        # Run a custom validation method if supplied:
        validate unless has_errors?
      end

      def form
        @form ||= Mutation.new(mutation_input_names)
      end

      def field_checked?(field, value)
        value = [value] unless value.is_a?(Array)

        send(field)&.in?(value) || form.send(field).in?(value)
      end

      def mutation_input_names
        input_filters.required_keys + input_filters.optional_keys
      end

      def permitted_params
        permitted_array_params + permitted_non_array_params -
          unpermitted_form_input_names
      end

      def permitted_array_params
        all_input_filters.map do |key, value|
          { key.to_sym => [] } if value.is_a?(::Mutations::ArrayFilter)
        end.compact
      end

      def permitted_non_array_params
        all_input_filters.map do |key, value|
          key unless value.is_a?(::Mutations::ArrayFilter)
        end.compact
      end

      def all_input_filters
        input_filters.optional_inputs.merge(input_filters.required_inputs)
      end

      # Fields defined here will be filtered
      def unpermitted_form_input_names
        []
      end

      def initialize_form_with_model_fields(model, fields)
        fields.each { |field| form.send("#{field}=", model&.send(field)) }
      end

      def user_inputs_for_fields(*fields)
        fields.map { |field| [field, send(field)] }.to_h
      end

      def locales_with_current_first
        I18n.available_locales.sort_by { |locale| (locale != I18n.locale).to_s }
      end
    end
  end
end
