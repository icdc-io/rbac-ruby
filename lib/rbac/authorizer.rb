# frozen_string_literal: true

require "yaml"

module Rbac
  # Authorizer class is responsible for checking
  # if user has access to perform some action.
  class Authorizer
    attr_reader :config

    # Load configuration from a YAML file.
    def initialize(config_file)
      @config = YAML.load_file(config_file)
    end

    def role_allows?(request)
      controller, action = fetch_params_from_request(request)
      config["features"][controller][action].include?(User.current_user.role)
    end

    private

    def fetch_params_from_request(request)
      controller = request.params[:controller]
      action = request.params[:action]
      [controller, action]
    end
  end
end
