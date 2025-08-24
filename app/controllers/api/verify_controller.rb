require 'net/http'
require 'uri'

module Api
  class VerifyController < ApplicationController
    protect_from_forgery with: :exception
    before_action :set_no_cache_headers
    def verify
      # Forward all query parameters to the external API
      uri = URI('https://submit.hackclub.com/api/verify')
      uri.query = request.query_string

      # Make the GET request to the external API
      response = Net::HTTP.get_response(uri)

      # Render the response back to the client
      render json: { status: response.code, body: JSON.parse(response.body) }
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
    def set_no_cache_headers
    response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end