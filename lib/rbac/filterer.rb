module Rbac::Filterer
  require "active_support/concern"
  extend ActiveSupport::Concern

  included do
    def self.filtered
      require 'yaml'

      scopes_map = YAML.load File.open ENV['SCOPES_MAP_FILE']

      scope = filters = scopes_map[self.name][@role]['scope']
      filters = scopes_map[self.name][@role]['filters']

      filters ? where(filters.map { |f| { f => instance_variable_get("@#{f}") } }.reduce Hash.new, :merge) : self.send(scope)
    end
  end
end