# -*- encoding: utf-8 -*-
require 'net/http'

module AlsTypograf
  # The request class
  module Request
    SERVICE_URL   = URI.parse('http://typograf.artlebedev.ru/webservices/typograf.asmx')
    RESULT_REGEXP = /<ProcessTextResult>\s*((.|\n)*?)\s*<\/ProcessTextResult>/

    # Process text with remote web-service
    # @param [String] text text to process
    # @param [Hash] options options for web-service
    def self.process_text(text, options = {})
      text    = text.encode(options[:encoding])

      #noinspection RubyStringKeysInHashInspection
      request = Net::HTTP::Post.new(SERVICE_URL.path, {
        'Content-Type' => 'text/xml',
        'SOAPAction'   => '"http://typograf.artlebedev.ru/webservices/ProcessText"'
      })

      request.body = <<-END_SOAP
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

      response = Net::HTTP.new(SERVICE_URL.host, SERVICE_URL.port).start do |http|
        http.request(request)
      end

      response.body.force_encoding(options[:encoding]) if response.body.respond_to?(:force_encoding)

      text = case response
             when Net::HTTPSuccess
               if RESULT_REGEXP =~ response.body
                 $1.gsub(/&gt;/, '>').gsub(/&lt;/, '<').gsub(/&amp;/, '&').gsub(/(\t|\n)$/, '')
               else
                 text
               end
             else
               text
             end

      text.encode(options[:encoding])
    rescue StandardError => e
      AlsTypograf.log_exception(e)
      text
    end
  end
end
