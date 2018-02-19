#  frozen_string_literal: true

module TPLink
  # Main class for TPLink.  This is likely the only class you will initialize.
  # @example
  #   sh = TPLink::SmartHome.new
  #
  #   # Get array of TPLink Devices (currently only dimmable lights work).
  #   sh.devices
  #
  #   # Find a device by name:
  #   light = sh.find("kitchen")
  #
  #   # Turn light on
  #   light.on
  #
  #   # Turn light off
  #   light.off
  #
  #   # Dim light to 50%
  #   light.on(50)
  class SmartHome
    # @!visibility private
    attr_reader :api
    # @param [Hash,String] config options for TPLink
    # @option config [String] :user Your Kasa user name
    # @option config [String] :password Your Kasa password
    # @option config [String] :uuid Your "device" (program) uuid.
    # @example
    #  smarthome = TPLink::SmartHome.new(user: kasa@example.com, password: password: 1234)
    #  kitchen_light = smarthome.find("kitchen")
    #  kitchen_light.on
    #  kitchen_light.off
    def initialize(config = {})
      @api = TPLink::API.new(config)
      reload
    end

    # Find a device by it's alias.
    # @param [String] a device alias.
    # @return [TPLink::Light] If device is a dimmable light.
    # @return [TPLink::RGBLight] if device is an RGB light.
    # @return [TPLink::Plug] if device is a smart plug.
    # @example Find your kitchen light
    #   smarthome.find("kitchen")
    def find(a)
      devices.find { |d| d.alias.match(/^#{a}$/i) }
    end

    # Find a device by it's alias.
    # @return [Array<TPLink::Light,TPLink::RGBLight,TPLlink::Plug>] an array of devices.
    # @example Turn everything off
    #   smarthome.devices.each { |device| device.off }
    def devices
      @devices ||= @raw_devices.map { |d| dev_to_class(d) }.compact
    end

    def send_data(device, data)
      @api.send_data(device, data)
    end

    # Reload devices from TPLink api.
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
      when 'IOT.SMARTPLUGSWITCH'
        return TPLink::Plug.new(self, device)
      end
      nil
    end
  end
end
