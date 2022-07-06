module Rbac::Filterer
  require "active_support/concern"
  extend ActiveSupport::Concern

  included do
    def self.filtered(params)
      require 'yaml'

      scopes_map = YAML.load File.open ENV['SCOPES_MAP_FILE']

      scope = filters = scopes_map[self.name][User.current_user.role]['scope']
      filters = scopes_map[self.name][User.current_user.role]['filters']

      filters ? where(filters.map { |f| { f => User.current_user.send(f) } }.reduce Hash.new, :merge) : self.send(scope)
    end
  end
end