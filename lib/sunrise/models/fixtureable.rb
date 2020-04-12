module Sunrise
  module Models
    module Fixtureable
      extend ActiveSupport::Concern

      included do
        def to_fixture
          filename = "spec/fixtures/#{self.class.table_name}.yml"

          key =
            if self.class.primary_key.is_a?(String)
              "#{self.class.primary_key}_#{send(self.class.primary_key)}"
            elsif self.class.export_to_fixture_name_fields.is_a?(Array)
              self.class.export_to_fixture_name_fields.map do |field|
                self.send(field).to_s.downcase
              end.join('_')
            end

          if File.file?(filename) &&
               YAML.load(File.read(filename)).try(:has_key?, key)
            puts "#{key} already exists in 'filename'"
          else
            File.open(filename, 'a') do |o|
              o.write({ "#{key}" => attributes }.to_yaml.gsub("---\n", ''))
              o.close
            end
          end

          %i[names descs].each do |relation|
            (try(relation) || []).map(&:to_fixture)
          end
        end
      end
    end
  end
end
