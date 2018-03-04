# frozen_string_literal: true

module TPLink
  # This class handles the configuration.
  # It is used internally and should not need to be called.
  # @!visibility private
  class Config
    def initialize(config = "#{ENV['HOME']}/.tp_link")
      @config_file = nil
      @config = get_config(config)
      raise 'User name not spcified in configuration.' \
        unless @config.key?('user')
      raise 'Password not specified in configuration.' \
        unless @config.key?('password')
      generate_uuid unless @config.key? 'uuid'
    end

    def generate_uuid
      if @config_file && @config['uuid'].nil?
        @config['uuid'] ||= SecureRandom.uuid
        File.open(@config_file, 'w') do |f|
          f.write @config.to_yaml
        end
      end
      @config['uuid']
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

    def to_hash
      {
        appType: app_type,
        cloudUserName: cloud_user_name,
        cloudPassword: cloud_password,
        terminalUUID: terminal_uuid
      }
    end

    def to_json(_o)
      to_hash.to_json
    end

    private

    def get_config(config)
      if config.is_a? String
        raise "Config file missing: #{config}" \
          unless File.exist?(config)
        @config_file = config
        return YAML.load_file(config) || {}
      elsif !config.is_a?(Hash)
        raise "Invalid config type #{config.class}"
      end
      config
    end
  end
end
