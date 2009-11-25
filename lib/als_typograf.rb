$KCODE = 'u'

require 'activesupport'
require 'httparty'

# ruby-implementation of ArtLebedevStudio.RemoteTypograf class (web-service client)
# @author Alexander Semyonov
module AlsTypograf
  # The request class
  class Request
    include HTTParty
    base_uri 'typograf.artlebedev.ru'
    format :xml
    headers('Content-Type' => 'text/xml',
            'Host' => 'typograf.artlebedev.ru',
            'SOAPAction' => '"http://typograf.artlebedev.ru/webservices/ProcessText"')

    # Process text with remote web-service
    # @param [String] text to process
    # @param [Hash] options for web-service
    def process_text(text, options = {})
      prepared_text = text.gsub(/&/, '&amp;').
                           gsub(/</, '&lt;').
                           gsub(/>/, '&gt;')
      soap_request = <<-END_SOAP
<?xml version="1.0" encoding="#{options[:encoding]}" ?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
<soap:Body>
 <ProcessText xmlns="http://typograf.artlebedev.ru/webservices/">
  <text>#{prepared_text}</text>
     <entityType>#{options[:entity_type]}</entityType>
     <useBr>#{options[:use_br]}</useBr>
     <useP>#{options[:use_p]}</useP>
     <maxNobr>#{options[:max_nobr]}</maxNobr>
  </ProcessText>
 </soap:Body>
</soap:Envelope>
      END_SOAP
      response = self.class.post('/webservices/typograf.asmx',
                                 :body => soap_request)
      response['soap:Envelope']['soap:Body']['ProcessTextResponse']['ProcessTextResult'].
        gsub(/&amp;/, '&').
        gsub(/&lt;/, '<').
        gsub(/&gt;/, '>').
        gsub(/\t$/, '')
    rescue
      text
    end
  end

  DEFAULT_OPTIONS = {
    :entity_type => 4,
    :use_br => 1,
    :use_p => 1,
    :max_nobr => 3,
    :encoding => 'UTF-8'
  }
  VALID_OPTIONS = DEFAULT_OPTIONS.keys.join('|')

  mattr_accessor :options
  @@options = DEFAULT_OPTIONS.dup

  # Get a global AlsTypograf option
  # @param [String, Symbol] option name
  def self.[](param)
    self.options[param.to_sym]
  end

  # Set a global AlsTypograf option
  # @param [String, Symbol] option name
  # @param [Numeric, String] value for the option
  def self.[]=(param, value)
    self.options[param.to_sym] = value
  end

  # Reset default options
  def self.default_options!
    @@options = DEFAULT_OPTIONS.dup
  end

  # Set option #entity_type to HTML (e. g. &nbsp;, &mdash;)
  def self.html_entities!
    self[:entity_type] = 1
  end

  # Set option #entity_type to XML (e. g. &#169;, &#155;)
  def self.xml_entities!
    self[:entity_type] = 2
  end

  # Set option #entity_type to nothing (e. g. —, ©, ×)
  def self.no_entities!
    self[:entity_type] = 3
  end

  # Set option #entity_type to mixed (e. g. &#169;, &nbsp;)
  def self.mixed_entities!
    self[:entity_type] = 4
  end

  # Option to replace \n with  +<br />+
  # @param [Boolean] to use +<br />+ or not
  def self.use_br=(value)
    self[:use_br] = value ? 1 : 0
  end

  # Option to wrap paragraphs with  +<p></p>+
  # @param [Boolean] to wrap para or not
  def self.use_p=(value)
    self[:use_p] = value ? 1 : 0
  end

  # How many symbols around dash to surround with +<nobr>+ tag
  # @param [Numeric, Boolean] symbols count
  def self.max_nobr=(value)
    self[:max_nobr] = value ? value : 0
  end

  def self.method_missing(method_name, *args)
    case method_name.to_s
    when /^(#{VALID_OPTIONS})=$/
      self[$1.to_sym] = args.first
    when /^(#{VALID_OPTIONS})$/
      self[method_name.to_sym]
    end
  end

  # Process text with Typograf web-service
  # @param [String] text to process
  # @param [Hash] custom_options the options to process current text with
  # @option custom_options [String] :entity_type Type of entities to use in processed text
  # @option custom_options [String] :use_br Whether or not to use +<br />+
  # @option custom_options [String] :use_p Whether or not to surround paras with +<p></p>+
  # @option custom_options [String] :encoding Encoding of text
  def self.process(text, custom_options = {})
    Request.new.process_text(text, custom_options.reverse_merge(options))
  end
end

if defined? ActiveRecord
  require 'als_typograf/active_record'
end
