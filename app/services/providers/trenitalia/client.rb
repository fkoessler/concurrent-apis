require "net/http"
require "uri"

module Providers
  module Trenitalia
    class Client
      API_URL = "http://localhost:8080/slow-api/5000"

      def fetch_tickets(*)
        response = Net::HTTP.get_response(URI.parse(API_URL))
        JSON.parse(response.body)
      end
    end
  end
end
