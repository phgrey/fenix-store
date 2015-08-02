require 'active_record'
module Fenix::Store
  class Base < ::ActiveRecord::Base
    self.abstract_class = true
    def self.canoname
      name.split('::').last.underscore
    end
    def self.table_name
      canoname.pluralize
    end
  end
end