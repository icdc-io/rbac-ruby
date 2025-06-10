# frozen_string_literal: true

require "active_support/core_ext/module"

module Rbac
  # Class Rbac::User describes authorized user
  # and stores its attributes required for RBAC filtration
  class User
    attr_reader :role, :attributes

    thread_mattr_accessor :current

    def initialize(role:, **attrs)
      @role = role
      @attributes = attrs.stringify_keys
    end
  end
end
