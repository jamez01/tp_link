# frozen_string_literal: true

module TPLink
  # Dimmable TPLink lights
  class Light
    attr_reader :alias, :name, :status, :type, :url, :model, :mac, :role
    attr_reader :same_region, :hw_id, :fw_id, :id, :hw_version, :fw_version
    def initialize(parent, dev)
      @parent = parent
      @alias = dev['alias']
      @name = dev['deviceName']
      @status = dev['status']
      @type = dev['deviceType']
      @url = dev['appServerUrl']
      @model = dev['deviceModel']
      @mac = dev['deviceMac']
      @role = dev['role']
      @same_region = dev['isSameRegion']
      @hw_id = dev['hwId']
      @fw_id = dev['fwId']
      @id = dev['deviceId']
      @hw_version = dev['deviceHwVer']
      @fw_version = dev['fwVer']
    end

    def on(b = 100)
      transition_light_state(1, b)
    end

    def off
      transition_light_state(0, 100)
    end

    def on?
      @status == 1
    end

    def off?
      !on?
    end

    private

    def transition_light_state(o, b)
      @parent.api.send_data(self,
                            "smartlife.iot.smartbulb.lightingservice": {
                              "transition_light_state": {
                                "on_off": o,
                                "brightness": b
                              }
                            })
    end
  end
end
