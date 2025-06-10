# frozen_string_literal: true

require "yaml"
require "active_support/concern"
require "active_support/core_ext/string"
require "active_record"

module Rbac
  # Filterer module defines some ActiveRecord methods
  # for filtering objects to which user does not have access.
  module Filterer
    extend ActiveSupport::Concern

    included do
      scope :rbac_filtered, lambda {
        scopes_map = YAML.safe_load_file(ENV.fetch("RBAC_SCOPES_FILE", "config/rbac_scopes.yml"))

        current_user = Rbac::User.current
        filters_config = scopes_map.dig(name, current_user.role)

        filters = filters_config["filters"]
        scope = filters_config["scope"]
        parent = filters_config["parent"]

        return send(scope) if scope

        return none unless filters || parent

        relation = all

        if filters
          additional_filters = filters.transform_values do |attribute|
            current_user.attributes[attribute]
          end
          relation = relation.where(additional_filters)
        end

        return relation unless parent

        relation.where(parent.underscore => parent.constantize.rbac_filtered)
      }
    end
  end
end

module ActiveRecord
  class Base
    include Rbac::Filterer
  end
end
