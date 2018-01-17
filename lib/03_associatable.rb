require_relative '02_searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor  :primary_key, :foreign_key, :class_name

  def model_class
    @class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, opt_hash = {})
    default = {
      primary_key: :id,
      foreign_key: "#{name}_id".to_sym,
      class_name: name.to_s.camelcase
    }

    default.merge!(opt_hash) unless opt_hash.empty?
    @primary_key = default[:primary_key]
    @foreign_key = default[:foreign_key]
    @class_name =  default[:class_name]
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, class_name, opt_hash = {})
    default = {
      primary_key: :id,
      foreign_key: "#{class_name.underscore}_id".to_sym,
      class_name: name.singularize.to_s.camelcase
    }

    default.merge!(opt_hash) unless opt_hash.empty?
    @primary_key = default[:primary_key]
    @foreign_key = default[:foreign_key]
    @class_name =  default[:class_name]
  end
end

module Associatable
  def belongs_to(name, opt_hash = {})
    options = BelongsToOptions.new(name, opt_hash)

    define_method(name) do
      foreign_key_val = self.send(options.foreign_key)

      name.to_s.capitalize.constantize.where(id: foreign_key_val).first
    end
  end

  def has_many(name, options = {})
    # ...
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  # Mixin Associatable here...
  extend Associatable
end
