require 'json'

module PlayStoreInfo
  module Readers
    def self.included(base)
      base.extend ClassMethods
    end

    def scrape_data
      self.class.accessors.each do |field, _|
        instance_variable_set("@#{field}", send("read_#{field}"))
      end
    end

    def to_json(*options)
      to_hash.to_json(*options)
    end

    def to_hash
      Hash[self.class.accessors.map { |field| [field.to_sym, send(field)] }]
    end

    module ClassMethods
      def readers(readers)
        readers.map { |field, _| attr_reader field }

        @_readers = readers
      end

      def accessors
        @_readers
      end
    end
  end
end
