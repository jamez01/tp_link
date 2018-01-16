# frozen_string_literal: true

module TPLink
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
