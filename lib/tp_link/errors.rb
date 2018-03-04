# frozen_string_literal: true

# Provides errors raised by the gem.

module TPLink
  # Handle Errrors related to TPLink's Cloud
  class DeviceOffline < StandardError
    def initialize
      super('Device Offline')
    end
  end
  class TPLinkCloudError < StandardError
    attr_reader :action
    def initialize(message, action = nil)
      super(message)
      @action = action
    end
  end
end
