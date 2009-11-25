module AlsTypograf
  module ActiveRecord
    def typograf_current_fields
      self.class.typograf_fields.each do |column, options|
        send(:"#{column}=",
             AlsTypograf.process(send(column).to_s,
                                 options))
      end
    end
  end
end

class ActiveRecord::Base
  def self.typograf(columns, options = {})
    unless respond_to?(:typograf_fields)
      cattr_accessor :typograf_fields
      self.typograf_fields = {}
    end

    case columns
    when Hash
      columns.each do |column, options|
        self.typograf_fields[column.to_sym] = options
      end
    when Array
      columns.each do |column|
        self.typograf_fields[column.to_sym] = {}
      end
    when Symbol, String
      self.typograf_fields[columns.to_sym] = options
    end

    before_validation :typograf_current_fields
    include AlsTypograf::ActiveRecord
  end
end
