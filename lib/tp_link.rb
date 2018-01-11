# frozen_string_literal: true
require 'logger'
require 'faraday'
require 'net/https'
require 'json'
require 'faraday_middleware'

# Main TP-Link Module
module TPLink
  @token_api = Faraday.new('https://wap.tplinkcloud.com') do |c|
    c.use FaradayMiddleware::ParseJson,       content_type: 'application/json'
    c.use Faraday::Response::Logger,          Logger.new('faraday.log')
    c.use FaradayMiddleware::FollowRedirects, limit: 3
    c.use Faraday::Response::RaiseError # raise exceptions on 40x, 50x responses
    c.use Faraday::Adapter::NetHttp
  end
end
