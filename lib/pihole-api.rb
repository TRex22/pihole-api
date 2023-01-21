require 'httparty'
require 'nokogiri'

require 'pihole-api/version'
require 'pihole-api/constants'

# Endpoints
require 'pihole-api/unauthorised_endpoints'
require 'pihole-api/authorised_endpoints'

require 'pihole-api/client'

module PiholeApi
  class Error < StandardError; end
end
