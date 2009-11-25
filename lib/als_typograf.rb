$KCODE = 'u'

require 'activesupport'
require 'httparty'
require 'als_typograf/request'

# ruby-implementation of ArtLebedevStudio.RemoteTypograf class (web-service client)
# @author Alexander Semyonov
module AlsTypograf
  HTML_ENTITIES = 1
  XML_ENTITIES = 2
  NO_ENTITIES = 3
  MIXED_ENTITIES = 4

  DEFAULT_OPTIONS = {
    :entity_type => NO_ENTITIES,
    :use_br => 1,
    :use_p => 1,
    :max_nobr => 3,
    :encoding => 'UTF-8'
  }
  VALID_OPTIONS = DEFAULT_OPTIONS.keys.join('|')

  mattr_accessor :options
  @@options = DEFAULT_OPTIONS.dup

  # Get a global AlsTypograf option
  # @param [String, Symbol] param option name
  def self.[](param)
    self.options[param.to_sym]
  end

  # Set a global AlsTypograf option
  # @param [String, Symbol] param option name
  # @param [Numeric, String] value value for the option
  def self.[]=(param, value)
    self.options[param.to_sym] = value
  end

  # Reset default options
  def self.default_options!
    @@options = DEFAULT_OPTIONS.dup
  end

  # Set option #entity_type to HTML (e. g. &nbsp;, &mdash;)
  def self.html_entities!
    self[:entity_type] = HTML_ENTITIES
  end

  # Set option #entity_type to XML (e. g. &#169;, &#155;)
  def self.xml_entities!
    self[:entity_type] = XML_ENTITIES
  end

  # Set option #entity_type to nothing (e. g. —, ©, ×)
  def self.no_entities!
    self[:entity_type] = NO_ENTITIES
  end

  # Set option #entity_type to mixed (e. g. &#169;, &nbsp;)
  def self.mixed_entities!
    self[:entity_type] = MIXED_ENTITIES
  end

  # Option to replace \n with  +<br />+
  # @param [Boolean] value to use +<br />+ or not
  def self.use_br=(value)
    self[:use_br] = value ? 1 : 0
  end

  # Option to wrap paragraphs with  +<p></p>+
  # @param [Boolean] value to wrap para or not
  def self.use_p=(value)
    self[:use_p] = value ? 1 : 0
  end

  # How many symbols around dash to surround with +<nobr>+ tag
  # @param [Numeric, Boolean] value symbols count
  def self.max_nobr=(value)
    self[:max_nobr] = value ? value : 0
  end

  def self.method_missing(method_name, *args)
    case method_name.to_s
    when /^(#{VALID_OPTIONS})=$/
      self[$1.to_sym] = args.first
    when /^(#{VALID_OPTIONS})$/
      self[method_name.to_sym]
    else
      super(method_name, *args)
    end
  end

  # Process text with Typograf web-service
  # @param [String] text text to process
  # @param [Hash] custom_options the options to process current text with
  # @option custom_options [String] :entity_type (NO_ENTITIES) Type of entities to use in processed text
  # @option custom_options [String] :use_br (1) Whether or not to use +<br />+
  # @option custom_options [String] :use_p (1) Whether or not to surround paras with +<p></p>+
  # @option custom_options [String] :max_nobr (3) How many symbols around dash to surround with +<nobr>+ tag
  # @option custom_options [String] :encoding ('UTF-8') Encoding of text
  def self.process(text, custom_options = {})
    Request.new.process_text(text, custom_options.reverse_merge(options))
  end
end

if defined? ActiveRecord
  require 'als_typograf/active_record'
end
