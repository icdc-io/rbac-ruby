module Rbac::Filterer
  require "active_support/concern"
  extend ActiveSupport::Concern

  included do
    def self.filtered
      require 'yaml'

      scopes_map = YAML.load File.open ENV['SCOPES_MAP_FILE']

      scope = filters = scopes_map[self.name][User.current_user.role]['scope']
      filters = scopes_map[self.name][User.current_user.role]['filters']

      if filters
        complex_filters = filters.select { |filter| filter.is_a? Hash }
        filters.delete_if { |filter| filter.is_a? Hash }

        relations = []
        complex_filters = complex_filters.inject(:merge).map do |model, fields|
          relations << model
          {
            model => fields.map do |field|
                  {field => User.current_user.send(field)}
                end.inject(:merge)
          }
        end.inject(:merge) unless complex_filters.empty?
        unless relations.empty?
          joins(relations.map(&:to_sym)).where(complex_filters.merge(filters.map { |f| { f => User.current_user.send(f) } }.reduce Hash.new, :merge))
        else
          where(filters.map { |f| { f => User.current_user.send(f) } }.reduce Hash.new, :merge)
        end
      else
        self.send(scope)
      end
    end
  end
end