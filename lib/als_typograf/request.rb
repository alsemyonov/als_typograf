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
    # @param [String] text text to process
    # @param [Hash] options options for web-service
    def process_text(text, options = {})
      soap_request = <<-END_SOAP
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
      response = self.class.post('/webservices/typograf.asmx', :body => soap_request)
      response['soap:Envelope']['soap:Body']['ProcessTextResponse']['ProcessTextResult'].gsub(/&amp;/, '&').gsub(/&lt;/, '<').gsub(/&gt;/, '>').gsub(/\t$/, '')
    rescue ::Exception => exception
      return text
    end
  end
end
