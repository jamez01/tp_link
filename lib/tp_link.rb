# frozen_string_literal: true

require 'logger'
require 'faraday'
require 'net/https'
require 'json'
require 'faraday_middleware'
require 'yaml'
require 'json'
require 'securerandom'
# Main TP-Link Module
module TPLink
  # TOKEN_API = Faraday.new('https://wap.tplinkcloud.com') do |c|
  #   c.use FaradayMiddleware::ParseJson,       content_type: 'application/json'
  #   c.use Faraday::Response::Logger,          Logger.new('faraday.log')
  #   c.use FaradayMiddleware::FollowRedirects, limit: 3
  ##   raise exceptions on 40x, 50x responses
  #   c.use Faraday::Response::RaiseError
  #   c.use Faraday::Adapter::NetHttp
  # end

  # Generates the configuration used by the tplink cloud API
  class Config
    def initialize(config_file = "#{ENV['HOME']}/.tp_link")
      raise "Config file missing: #{config_file}" \
        unless File.exist?(config_file)
      @config = YAML.load_file(config_file) || {}
      raise 'User name not spcified in config file.' \
        unless @config.key?('user')
      raise 'Password not specified in config file.' \
        unless @config.key?('password')
      generate_uuid unless @config.key? 'uuid'
    end

    def generate_uuid
      @config['uuid'] ||= SecureRandom.uuid
      File.open(config_file, 'w') { |f| f.write @config.to_yaml }
    end

    def app_type
      'Kasa_Android'
    end

    def terminal_uuid
      @config['uuid']
    end

    def cloud_user_name
      @config['user']
    end

    def cloud_password
      @config['password']
    end

    def to_json
      {
        appType: app_type,
        cloudUserName: cloud_user_name,
        cloudPassword: cloud_password,
        terminalUUID: terminal_uuid
      }.to_json
    end
  end

  # Communicate with the tplink cloud api
  class API
    DEFAULT_OPTIONS = {
      config_file: "#{ENV['HOME']}/.tp_link"
    }.freeze
    def initialize(opts = {})
      options = DEFAULT_OPTIONS.merge(opts)
      @config = Config.new(options[:config_file])
    end
  end
end
