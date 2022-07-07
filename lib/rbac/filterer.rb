module Rbac::Filterer
  require "active_support/concern"
  extend ActiveSupport::Concern

  included do
    def self.filtered
      require 'yaml'

      scopes_map = YAML.load File.open ENV['SCOPES_MAP_FILE']

      filters_config = scopes_map[self.name][User.current_user.role]

      filters = filters_config['filters']
      scope = filters_config['scope']
      parent = filters_config['parent']

      # TODO: refactor it and remove complexity of this code 
      if parent
        if filters
          additional_filters = filters.map { |field_name, attribute|  { field_name => User.current_user.send(attribute) } }.reduce Hash.new, :merge
          parent.constantize.filtered.map do |parent_object|
            where(additional_filters.merge(parent.downcase.to_sym => parent_object))
          end.flatten
        else
          parent.constantize.filtered.map do |parent_object|
            where(parent.downcase.to_sym => parent_object)
          end.flatten
        end
      elsif filters
        where(filters.map { |field_name, attribute|  { field_name => User.current_user.send(attribute) } }.reduce Hash.new, :merge)
      elsif scope
        self.send(scope)
      else
        []
      end
    end
  end
end