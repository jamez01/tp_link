#  frozen_string_literal: true

module TPLink
  # Main class for TPLink
  class SmartHome
    attr_reader :api
    def initialize
      @api = TPLink::API.new
      reload
    end

    def find(a)
      devices.find { |d| d.alias.match(/^#{a}$/i) }
    end

    def devices
      @devices ||= @raw_devices.map { |d| dev_to_class(d) }
    end

    def reload
      @raw_devices = @api.device_list
      @devices = nil
    end

    private

    # TODO: Test LB130, LB120, LB110, and BR30 devices.
    def dev_to_class(device)
      case device['deviceType']
      when 'IOT.SMARTBULB'
        return TPLink::Light.new(self, device) \
          if device['deviceModel'].match?(/^(LB100|LB110|BR30)/)
        return TPLink::RGBLight.new(self, device) \
          if device['deviceModel'].match?(/^(LB130|LB120)/)
      end
    end
  end
end
