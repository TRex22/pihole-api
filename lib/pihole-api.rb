require 'httparty'
require 'nokogiri'

require 'PiholeApi/version'
require 'PiholeApi/constants'

# Endpoints
require 'PiholeApi/unauthorised_endpoints'

require 'PiholeApi/client'

module PiholeApi
  class Error < StandardError; end
end
