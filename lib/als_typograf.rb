$KCODE = 'u'

require 'activesupport'
require 'httparty'

module AlsTypograf
  class Request
    include HTTParty
    base_uri 'typograf.artlebedev.ru'
    format :xml
    headers('Content-Type' => 'text/xml',
            'Host' => 'typograf.artlebedev.ru',
            'SOAPAction' => '"http://typograf.artlebedev.ru/webservices/ProcessText"')

    def process_text(text, options = {})
      prepared_text = text.gsub(/&/, '&amp;').
                           gsub(/</, '&lt;').
                           gsub(/>/, '&gt;')
      response = self.class.post('/webservices/typograf.asmx',
                                 :body => soap_request(prepared_text, options))
      result = response['soap:Envelope']['soap:Body']['ProcessTextResponse']['ProcessTextResult'].
               gsub(/&amp;/, '&').
               gsub(/&lt;/, '<').
               gsub(/&gt;/, '>').
               gsub(/\t$/, '')
    rescue
      text
    end

  protected

    def soap_request(text, options = {})
      soap_body = <<-END_SOAP
<?xml version="1.0" encoding="#{options[:encoding]}" ?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
<soap:Body>
 <ProcessText xmlns="http://typograf.artlebedev.ru/webservices/">
  <text>#{text}</text>
     <entityType>#{options[:entity_type]}</entityType>
     <useBr>#{options[:use_br]}</useBr>
     <useP>#{options[:use_p]}</useP>
     <maxNobr>#{options[:max_nobr]}</maxNobr>
  </ProcessText>
 </soap:Body>
</soap:Envelope>
      END_SOAP
    end
  end

  mattr_accessor :options

  DEFAULT_OPTIONS = {
    :entity_type => 4,
    :use_br => 1,
    :use_p => 1,
    :max_nobr => 3,
    :encoding => 'UTF-8'
  }
  @@options = DEFAULT_OPTIONS.dup


  def self.[]=(param, value)
    self.options[param] = value
  end

  def self.default_options!
    @@options = DEFAULT_OPTIONS.dup
  end

  def self.html_entities!
    self[:entity_type] = 1
  end

  def self.xml_entities!
    self[:entity_type] = 2
  end

  def self.no_entities!
    self[:entity_type] = 3
  end

  def self.mixed_entities!
    self[:entity_type] = 4
  end

  def self.p!(value)
    self[:use_p] = value ? 1 : 0
  end

  def self.nobr!(value)
    self[:max_nobr] = value ? value : 0
  end

  def self.process(text)
    Request.new.process_text(text, options)
  end
end
