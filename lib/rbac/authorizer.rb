# frozen_string_literal: true

require "yaml"

module Rbac
  # Authorizer module is responsible for checking
  # if user has access to perform some action.
  module Authorizer
    require "active_support/concern"
    extend ActiveSupport::Concern

    def authorize_user(attrs)
      Rbac::User.current = Rbac::User.new(**attrs)
    end

    def user_role_authorized?
      controller = params[:controller]
      action = params[:action]
      routes_config.dig("features", controller, action)&.include?(Rbac::User.current.role)
    end

    private

    # Load configuration from a YAML file.
    def routes_config
      @routes_config ||= YAML.safe_load_file(ENV.fetch("RBAC_ROUTES_FILE", "config/rbac_routes.yaml"))
    end
  end
end

module ActionController
  class API
    include Rbac::Authorizer
  end
end
