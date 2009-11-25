module AlsTypograf
  module ActiveRecord
    # Run AlsTypograf#process on configured columns.
    # Used to run as before_validation filter (automaticaly added on ActiveRecord::Base.typograf)
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
  # Specify columns to typograf
  # @overload typograf(column_name, options)
  #   Typograf only specified column with specified or default options
  #   @example typograf column with default options
  #     typograf :content # will typograf +content+ with default AlsTypograf options
  #   @example typograf column with custom options
  #     typograf :title, :use_br => false # will typograf +title+ without replacing +\n+ with <br />
  #   @param [String, Symbol] column_name name of the column to typograf
  #   @param [Hash] options custom options to AlsTypograf#process method
  # @overload typograf(column1, column2, ..., options)
  #   Typograf every specified columns with default options
  #   @example typograf columns with common custom options
  #     typograf :skills, :achievements, :description, :encoding => 'CP1251'
  #   @param [String, Symbol] column1 first column name
  #   @param [String, Symbol] column2 next column name
  #   @param [String, Symbol] ... specify all columns, you need
  #   @param [Hash] options options to AlsTypograf#process method for all specified fields
  # @overload typograf(columns_with_options)
  #   Typograf specified columns with specified options
  #   @example typograf specified columns with specified options
  #     typograf :foo => {:use_br => false}, :bar => {:use_p => false}
  #   @param [Hash] columns_with_options column names with correspond options to AlsTypograf#process method
  def self.typograf(*columns)
    unless respond_to?(:typograf_fields)
      cattr_accessor :typograf_fields
      self.typograf_fields = {}
    end

    case columns.first
    when Hash
      columns.first.each do |column, options|
        self.typograf_fields[column.to_sym] = options
      end
    when Array, Symbol, String
      options = columns.extract_options!
      columns.each do |column|
        self.typograf_fields[column.to_sym] = options
      end
    end

    before_validation :typograf_current_fields
    include AlsTypograf::ActiveRecord
  end
end
