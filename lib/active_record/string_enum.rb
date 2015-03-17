require "active_record/string_enum/version"
require 'active_record/type/value'
require 'active_support/core_ext/object/deep_dup'

module ActiveRecord
  # Declare an enum attribute where the values map to integers in the database,
  # but can be queried by name. Example:
  #
  #   class Conversation < ActiveRecord::Base
  #     enum status: [ :active, :archived ]
  #   end
  #
  #   # conversation.update! status: :active
  #   conversation.active!
  #   conversation.active? # => true
  #   conversation.status  # => "active"
  #
  #   # conversation.update! status: :archived
  #   conversation.archived!
  #   conversation.archived? # => true
  #   conversation.status    # => "archived"
  #
  #   # conversation.update! status: :archived
  #   conversation.status = "archived"
  #
  #   # conversation.update! status: nil
  #   conversation.status = nil
  #   conversation.status.nil? # => true
  #   conversation.status      # => nil
  #
  # Scopes based on the allowed values of the enum field will be provided
  # as well. With the above example:
  #
  #   Conversation.active
  #   Conversation.archived
  #
  # Of course, you can also query them directly if the scopes doesn't fit your
  # needs:
  #
  #   Conversation.where(status: [:active, :archived])
  #   Conversation.where.not(status: :active)
  #
  # You can set the default value from the database declaration, like:
  #
  #   create_table :conversations do |t|
  #     t.column :status, :string, default: :active
  #   end
  #
  # In rare circumstances you might need to access the mapping directly.
  # The mappings are exposed through a class method with the pluralized attribute
  # name.
  #
  #   Conversation.statuses[0] # => :active
  #   Conversation.statuses[1] # => :archived
  #

  module StringEnum
    def self.extended(base) # :nodoc:
      base.class_attribute(:defined_str_enums)
      base.defined_str_enums = {}
    end

    def inherited(base) # :nodoc:
      base.defined_str_enums = defined_str_enums.deep_dup
      super
    end

    class EnumType < Type::Value
      def initialize(name, mapping)
        @name = name
        @mapping = mapping
      end

      def cast(value)
        return if value.blank?

        if mapping.include?(value.to_s)
          value.to_sym
        else
          raise ArgumentError, "'#{value}' is not a valid #{name}"
        end
      end

      def deserialize(value)
        return if value.nil?
        value.to_sym
      end

      def serialize(value)
        value.to_s
      end

      protected

      attr_reader :name, :mapping
    end

    def str_enum(definitions)
      klass = self
      definitions.each do |name, values|
        # statuses = [ ]
        enum_values = values.map(&:to_s)
        name        = name.to_sym

        # def self.statuses statuses end
        detect_enum_conflict!(name, name.to_s.pluralize, true)
        klass.singleton_class.send(:define_method, name.to_s.pluralize) { values }

        detect_enum_conflict!(name, name)
        detect_enum_conflict!(name, "#{name}=")

        # TODO: in Rails 4.2.1 this will be legal:
        # attribute name, EnumType.new(name, enum_values)
        # instead of the next lines:
        type = EnumType.new(name, enum_values)
        define_method("#{name}=") do |value|
          write_attribute(name, type.cast(value))
        end

        define_method(name) { type.deserialize(self[name]) }

        _enum_methods_module.module_eval do
          enum_values.each do |value|
            # def active?() status == :active end
            klass.send(:detect_enum_conflict!, name, "#{value}?")
            define_method("#{value}?") { self[name] == value }

            # def active!() update! status: :active end
            klass.send(:detect_enum_conflict!, name, "#{value}!")
            define_method("#{value}!") { update! name => value }

            # scope :active, -> { where status: :active }
            klass.send(:detect_enum_conflict!, name, value, true)
            klass.scope value, -> { klass.where name => value }
          end
        end
        defined_str_enums[name.to_s] = enum_values
      end
    end

    private
      def _enum_methods_module
        @_enum_methods_module ||= begin
          mod = Module.new
          include mod
          mod
        end
      end

      ENUM_CONFLICT_MESSAGE = \
        "You tried to define an enum named \"%{enum}\" on the model \"%{klass}\", but " \
        "this will generate a %{type} method \"%{method}\", which is already defined " \
        "by %{source}."

      def detect_enum_conflict!(enum_name, method_name, klass_method = false)
        if klass_method && dangerous_class_method?(method_name)
          raise ArgumentError, ENUM_CONFLICT_MESSAGE % {
            enum: enum_name,
            klass: self.name,
            type: 'class',
            method: method_name,
            source: 'Active Record'
          }
        elsif !klass_method && dangerous_attribute_method?(method_name)
          raise ArgumentError, ENUM_CONFLICT_MESSAGE % {
            enum: enum_name,
            klass: self.name,
            type: 'instance',
            method: method_name,
            source: 'Active Record'
          }
        elsif !klass_method && method_defined_within?(method_name, _enum_methods_module, Module)
          raise ArgumentError, ENUM_CONFLICT_MESSAGE % {
            enum: enum_name,
            klass: self.name,
            type: 'instance',
            method: method_name,
            source: 'another enum'
          }
        end
      end
  end
end
