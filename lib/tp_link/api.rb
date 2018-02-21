# frozen_string_literal: true

# TPLink Module
module TPLink
  # Talk to TPLink's API.  This class is use internally.  You should not need to call it.
  # @!visibility private
  class API
    # @!visibility private
    DEFAULT_PARAMS = {
      'appName' =>  'Kasa_Android',
      'termID' =>  proc { @config.terminal_uuid },
      'appVer' =>  '1.4.4.607',
      'ospf' =>  'Android+6.0.1',
      'netType' =>  'wifi',
      'locale' =>  'es_ES'
    }.freeze

    # @!visibility private
    DEFAULT_HEADERS = {
      'Connection' => 'Keep-Alive',
      'User-Agent' => 'Dalvik/2.1.0 (Linux; U; Android 6.0.1; ' \
                                'A0001 Build/M4B30X)',
      'Content-Type' => 'applicatoin/json;charset=utf-8',
      'Accept' => 'application/json, text/plain, */*'
    }.freeze

    # # @!visibility private
    # TOKEN_API = Faraday.new('https://wap.tplinkcloud.com') do |c|
    #   c.request :json
    #   c.response :json, content_type: /\bjson$/i
    #   c.adapter Faraday.default_adapter
    #   c.params.merge!(DEFAULT_PARAMS)
    #   c.headers.merge!(DEFAULT_HEADERS)
    # end

    # @!visibility private
    TPLINK_API = Faraday.new('https://wap.tplinkcloud.com') do |c|
      c.request :json
      c.response :json, content_type: /\bjson$/i
      c.adapter Faraday.default_adapter
      c.params.merge!(DEFAULT_PARAMS)
      c.headers.merge!(DEFAULT_HEADERS)
    end

    # @!visibility private
    DEFAULT_OPTIONS = {
      config: "#{ENV['HOME']}/.tp_link"
    }.freeze
    def initialize(opts = {})
      options = DEFAULT_OPTIONS.merge(opts)
      @config = Config.new(options[:config])
    end

    def token(regen = false)
      return @token if @token && regen == false
      response = TPLINK_API.post do |req|
        req.body = { method: 'login', url: 'https://wap.tplinkcloud.com',
                     params: @config.to_hash }.to_json
      end
      @token = parse_response(response)['token']
    end

    def device_list
      @device_list if @device_list
      response = TPLINK_API.post do |req|
        req.params['token'] = token
        req.body = { method: 'getDeviceList' }.to_json
      end
      @device_list = parse_response(response)['deviceList']
    end

    def send_data(device, data)
      conn = data_connection(device)
      res = conn.post do |req|
        req.body = { method: 'passthrough',
                     params: { deviceId: device.id,
                               requestData: data.to_json } }.to_json
      end
      parse_response(res)
    end

    private

    def data_connection(device)
      Faraday.new(device.url) do |c|
        c.request :json
        c.response :json, content_type: /\bjson$/i
        c.adapter Faraday.default_adapter
        c.params['token'] = token
        c.headers.merge!(DEFAULT_HEADERS)
      end
    end

    def parse_response(res)
      raise TPLink::TPLinkCloudError, 'Generic TPLinkCloud Error' unless res.success?
      response = JSON.parse(res.body)
      raise TPLink::DeviceOffline if response['error_code'].to_i == -20571
      raise TPLink::TPLinkCloudError, 'TPLinkCloud API Error' \
        unless response['error_code'].to_i.zero?
      raise TPLink::TPLinkCloudError, 'No respone data' \
        unless res.body['result']
      if response['result'].key?('responseData') && \
         response['result']['responseData'].class == String
        response['result']['responseData'] = \
          JSON.parse(response['result']['responseData'])
      end
      response['result']
    end
  end
end
