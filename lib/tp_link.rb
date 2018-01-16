# frozen_string_literal: true

require 'logger'
require 'faraday'
require 'net/https'
require 'json'
require 'faraday_middleware'
require 'yaml'
require 'json'
require 'securerandom'

require 'tp_link/config.rb'
require 'tp_link/api.rb'

# TOKEN_API = Faraday.new('https://wap.tplinkcloud.com') do |c|
#   c.use FaradayMiddleware::ParseJson,       content_type: 'application/json'
#   c.use Faraday::Response::Logger,          Logger.new('faraday.log')
#   c.use FaradayMiddleware::FollowRedirects, limit: 3
##   raise exceptions on 40x, 50x responses
#   c.use Faraday::Response::RaiseError
#   c.use Faraday::Adapter::NetHttp
# end

# Generates the configuration used by the tplink cloud API
