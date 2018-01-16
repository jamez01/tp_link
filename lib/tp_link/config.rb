# frozen_string_literal: true

module TPLink
  # Configuration
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
end
