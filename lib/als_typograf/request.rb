# -*- encoding: utf-8 -*-
require 'net/http'

module AlsTypograf
  # The request class
  module Request
    SERVICE_URL = URI.parse('http://typograf.artlebedev.ru/webservices/typograf.asmx')
    SOAP_ACTION = '"http://typograf.artlebedev.ru/webservices/ProcessText"'

    RESULT_REGEXP = /<ProcessTextResult>\s*((.|\n)*?)\s*<\/ProcessTextResult>/

    # Process text with remote web-service
    # @param [String] text text to process
    # @param [Hash] options options for web-service
    # @return [String]
    def self.process_text(text, options = {})
      text = text.encode(options[:encoding])

      body = <<-END_SOAP
<?xml version="1.0" encoding="#{options[:encoding]}" ?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
<soap:Body>
 <ProcessText xmlns="http://typograf.artlebedev.ru/webservices/">
  <text>#{text.gsub(/&/, '&amp;').gsub(/</, '&lt;').gsub(/>/, '&gt;')}</text>
     <entityType>#{options[:entity_type]}</entityType>
     <useBr>#{options[:use_br]}</useBr>
     <useP>#{options[:use_p]}</useP>
     <maxNobr>#{options[:max_nobr]}</maxNobr>
  </ProcessText>
 </soap:Body>
</soap:Envelope>
      END_SOAP

      make_request(body, options) || text
    rescue StandardError => e
      AlsTypograf.log_exception(e)
      text
    end

    def self.make_request(text, options)
      request = Net::HTTP::Post.new(SERVICE_URL.path, 'Content-Type' => 'text/xml', 'SOAPAction' => SOAP_ACTION)
      request.body = text
      response = Net::HTTP.new(SERVICE_URL.host, SERVICE_URL.port).start { |http| http.request(request) }
      return nil unless response.is_a?(Net::HTTPSuccess)
      result = response.body
      result.force_encoding(options[:encoding]) if result.respond_to?(:force_encoding)
      result = Regexp.last_match[1].gsub(/&gt;/, '>').gsub(/&lt;/, '<').gsub(/&amp;/, '&').gsub(/(\t|\n)$/, '') if RESULT_REGEXP =~ result
      result.encode(options[:encoding])
    end
  end
end
