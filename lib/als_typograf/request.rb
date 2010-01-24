require 'net/http'

module AlsTypograf
  # The request class
  module Request
    @@url = URI.parse('http://typograf.artlebedev.ru/webservices/typograf.asmx')
    @@result_regexp = /<ProcessTextResult>\s*((.|\n)*?)\s*<\/ProcessTextResult>/m

    # Process text with remote web-service
    # @param [String] text text to process
    # @param [Hash] options options for web-service
    def self.process_text(text, options = {})
      request = Net::HTTP::Post.new(@@url.path, {
        'Content-Type' => 'text/xml',
        'SOAPAction' => '"http://typograf.artlebedev.ru/webservices/ProcessText"'
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

      response = Net::HTTP.new(@@url.host, @@url.port).start do |http|
        http.request(request)
      end

      case response
      when Net::HTTPSuccess
        result = if @@result_regexp =~ response.body
          $1.gsub(/&gt;/, '>').gsub(/&lt;/, '<').gsub(/&amp;/, '&').gsub(/(\t|\n)$/, '')
        else
          text
        end
      else
        text
      end
    rescue ::Exception => exception
      text
    end
  end
end
