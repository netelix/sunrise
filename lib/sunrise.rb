# frozen_string_literal: true

require 'rails'
require 'active_support/core_ext/numeric/time'
require 'active_support/dependencies'
require 'orm_adapter'
require 'set'
require 'securerandom'

module Sunrise
  module Controllers
    autoload :Helpers,        'sunrise/controllers/helpers'
    autoload :ModalForm,      'sunrise/controllers/modal_form'
    autoload :MutationForm,   'sunrise/controllers/mutation_form'
    autoload :Modalable,      'sunrise/controllers/modalable'
    autoload :TokenLogin,     'sunrise/controllers/token_login'
  end

  module Models
    autoload :Fixtureable,        'sunrise/models/fixtureable'
    autoload :Nameable,           'sunrise/models/nameable'
    autoload :Name,               'sunrise/models/name'
    autoload :Nameable,           'sunrise/models/nameable'
    autoload :Content,            'sunrise/models/content'
    autoload :Contentable,        'sunrise/models/contentable'
    autoload :Page,               'sunrise/models/page'
    autoload :User,               'sunrise/models/user'
  end

  module SpecHelpers

    autoload :DeviseFeature,   'sunrise/spec_helpers/devise_feature'
    autoload :UserDevices,     'sunrise/spec_helpers/user_devices'
    autoload :ModalForm,       'sunrise/spec_helpers/modal_form'

    if Rails.env.test?
      require 'sunrise/spec_helpers/user_devices'
      require 'sunrise/spec_helpers/devices_helper'
      require 'sunrise/spec_helpers/feature_spec_helpers'
      require 'sunrise/spec_helpers/sidekiq'
      require 'sunrise/spec_helpers/summernote_helper'
      require 'sunrise/spec_helpers/save_screenshot_on_failure'
      require 'sunrise/spec_helpers/wait_for_ajax'
    end
  end

  # Scoped views. Since it relies on fallbacks to render default views, it's
  # turned off by default.
  mattr_accessor :scoped_views
  @@scoped_views = false

  # PRIVATE CONFIGURATION

  # Store scopes mappings.
  mattr_reader :mappings
  @@mappings = {}

  # Define a set of modules that are called when a mapping is added.
  mattr_reader :helpers
  @@helpers = Set.new
  @@helpers << Sunrise::Controllers::Helpers

  # Default way to set up Sunrise. Run rails generate sunrise_install to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
  end

  class Getter
    def initialize(name)
      @name = name
    end

    def get
      ActiveSupport::Dependencies.constantize(@name)
    end
  end

  def self.ref(arg)
    ActiveSupport::Dependencies.reference(arg)
    Getter.new(arg)
  end

  def self.available_router_name
    router_name || :main_app
  end

  # Get the mailer class from the mailer reference object.
  def self.mailer
    @@mailer_ref.get
  end

  # Set the mailer reference object to access the mailer.
  def self.mailer=(class_name)
    @@mailer_ref = ref(class_name)
  end
  self.mailer = "Sunrise::Mailer"

  # Small method that adds a mapping to Sunrise.
  def self.add_mapping(resource, options)
    mapping = Sunrise::Mapping.new(resource, options)
    @@mappings[mapping.name] = mapping
    @@default_scope ||= mapping.name
    @@helpers.each { |h| h.define_helpers(mapping) }
    mapping
  end

  # Register available sunrise modules. For the standard modules that Sunrise provides, this method is
  # called from lib/sunrise/modules.rb. Third-party modules need to be added explicitly using this method.
  #
  # Note that adding a module using this method does not cause it to be used in the authentication
  # process. That requires that the module be listed in the arguments passed to the 'sunrise' method
  # in the model class definition.
  #
  # == Options:
  #
  #   +model+      - String representing the load path to a custom *model* for this module (to autoload.)
  #   +controller+ - Symbol representing the name of an existing or custom *controller* for this module.
  #   +route+      - Symbol representing the named *route* helper for this module.
  #   +strategy+   - Symbol representing if this module got a custom *strategy*.
  #   +insert_at+  - Integer representing the order in which this module's model will be included
  #
  # All values, except :model, accept also a boolean and will have the same name as the given module
  # name.
  #
  # == Examples:
  #
  #   Sunrise.add_module(:party_module)
  #   Sunrise.add_module(:party_module, strategy: true, controller: :sessions)
  #   Sunrise.add_module(:party_module, model: 'party_module/model')
  #   Sunrise.add_module(:party_module, insert_at: 0)
  #
  def self.add_module(module_name, options = {})
    options.assert_valid_keys(:strategy, :model, :controller, :route, :no_input, :insert_at)

    ALL.insert (options[:insert_at] || -1), module_name

    if strategy = options[:strategy]
      strategy = (strategy == true ? module_name : strategy)
      STRATEGIES[module_name] = strategy
    end

    if controller = options[:controller]
      controller = (controller == true ? module_name : controller)
      CONTROLLERS[module_name] = controller
    end

    NO_INPUT << strategy if options[:no_input]

    if route = options[:route]
      case route
      when TrueClass
        key, value = module_name, []
      when Symbol
        key, value = route, []
      when Hash
        key, value = route.keys.first, route.values.flatten
      else
        raise ArgumentError, ":route should be true, a Symbol or a Hash"
      end

      URL_HELPERS[key] ||= []
      URL_HELPERS[key].concat(value)
      URL_HELPERS[key].uniq!

      ROUTES[module_name] = key
    end

    if options[:model]
      path = (options[:model] == true ? "sunrise/models/#{module_name}" : options[:model])
      camelized = ActiveSupport::Inflector.camelize(module_name.to_s)
      Sunrise::Models.send(:autoload, camelized.to_sym, path)
    end

    Sunrise::Mapping.add_module module_name
  end

  # Include helpers in the given scope to AC and AV.
  def self.include_helpers(scope)
    ActiveSupport.on_load(:action_controller) do
      include scope::Helpers if defined?(scope::Helpers)
    end

    ActiveSupport.on_load(:action_view) do
    end
  end

  # Regenerates url helpers considering Sunrise.mapping
  def self.regenerate_helpers!
  end
end

require 'sunrise/rails'