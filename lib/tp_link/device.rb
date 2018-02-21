# frozen_string_literal: true

module TPLink
  # Generic class for all TPLink devices0
  class Device
    # Returns satus of device.
    # @return [Boolean<1>] if device is on.
    # @return [Boolean<0>] if device is off.
    attr_reader :status

    # Returns alais of device.
    # @return [String] Device alias (name in kasa app).
    attr_reader :alias

    # Returns name of device.
    # @return [String] Name of device (e.g. TP Link Smart Plug).
    attr_reader :name

    # @!visibility private
    attr_reader :type, :url, :model, :mac, :role
    # @!visibility private
    attr_reader :same_region, :hw_id, :fw_id, :id, :hw_version, :fw_version

    # @!visibility private
    # This should only be called internally
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

    # Get Wifi signal strength in dB
    # @returns [Integer]
    def rssi
      reload
      @rssi
    end
    # Reload data / device state
    def reload
      res = @parent.send_data(self,
                        "system":
                         { "get_sysinfo": nil },
                        "emeter": { "get_realtime": nil })
      @rssi = res["responseData"]["system"]["get_sysinfo"]["rssi"]
      case self.class.to_s
      when 'TPLink::Light'
        reload_light(res)
      when 'TPLink::Plug'
        reload_plug(res)
      end
      true
    end

    # {"error_code":0,"result":{"responseData":"{\"system\":{\"get_sysinfo\":{\"sw_ver\":\"1.5.1 Build 171109 Rel.165500\",\"hw_ver\":\"1.0\",\"type\":\"IOT.SMARTPLUGSWITCH\",\"model\":\"HS105(US)\",\"mac\":\"B0:4E:26:19:7B:89\",\"dev_name\":\"Smart Wi-Fi Plug Mini\",\"alias\":\"Smart Plug\",\"relay_state\":0,\"on_time\":0,\"active_mode\":\"schedule\",\"feature\":\"TIM\",\"updating\":0,\"icon_hash\":\"\",\"rssi\":-59,\"led_off\":0,\"longitude_i\":-848233,\"latitude_i\":435245,\"hwId\":\"E5D7E6089B060EF662783C23AE110522\",\"fwId\":\"00000000000000000000000000000000\",\"deviceId\":\"80067D31EE9AD601BC6EECEF303E2B4D19662478\",\"oemId\":\"003E098AF0D44D4BAB796B3F6A7A830E\",\"err_code\":0}},\"emeter\":{\"get_realtime\":{\"err_code\":-1,\"err_msg\":\"module not support\"}}}"}}


    # Turn device on
    def on; end

    # Turn device off
    def off; end

    # @return [True] if device is on.
    # @return [False] if device is off.
    def on?
      reload
      @status == 1
    end

    # @return [True] if device is off.
    # @return [False] if device is on.
    def off?
      !on?
    end

    private
    def reload_plug(res)
      @status = res['responseData']['system']['get_sysinfo']['relay_state']
    end

    def reload_light(res)
      @status = res['responseData']['system']['get_sysinfo']['light_state']['on_off']
    end

    def reload_rgb(res)
      # TODO: Add variables for Hue, and Saturation
      @status = res['responseData']['system']['get_sysinfo']['light_state']['on_off']
    end
  end
end
