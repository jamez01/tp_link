# frozen_string_literal: true

# TPLink Module
module TPLink
  # Talk to TPLink's API
  class API
    DEFAULT_PARAMS = {
      'appName' =>  'Kasa_Android',
      'termID' =>  proc { @config.terminal_uuid },
      'appVer' =>  '1.4.4.607',
      'ospf' =>  'Android+6.0.1',
      'netType' =>  'wifi',
      'locale' =>  'es_ES'
    }.freeze
    DEFAULT_HEADERS = {
      'Connection' => 'Keep-Alive',
      'User-Agent' => 'Dalvik/2.1.0 (Linux; U; Android 6.0.1; ' \
                                'A0001 Build/M4B30X)',
      'Content-Type' => 'applicatoin/json;charset=utf-8',
      'Accept' => 'application/json, text/plain, */*'
    }.freeze
    TOKEN_API = Faraday.new('https://wap.tplinkcloud.com') do |c|
      c.request :json
      c.response :json, content_type: /\bjson$/i
      c.adapter Faraday.default_adapter
      c.params.merge!(DEFAULT_PARAMS)
      c.headers.merge!(DEFAULT_HEADERS)
    end

    DEVICE_API = Faraday.new('https://wap.tplinkcloud.com') do |c|
      c.request :json
      c.response :json, content_type: /\bjson$/i
      c.adapter Faraday.default_adapter
      c.params.merge!(DEFAULT_PARAMS)
      c.headers.merge!(DEFAULT_HEADERS)
    end

    DEFAULT_OPTIONS = {
      config: "#{ENV['HOME']}/.tp_link"
    }.freeze
    def initialize(opts = {})
      options = DEFAULT_OPTIONS.merge(opts)
      @config = Config.new(options[:config])
    end

    def token(regen = false)
      return @token if @token && regen == false
      response = TOKEN_API.post do |req|
        req.body = { method: 'login', url: 'https://wap.tplinkcloud.com',
                     params: @config.to_hash }.to_json
      end
      @token = parse_response(response)['token']
    end

    def device_list
      response = DEVICE_API.post do |req|
        req.params['token'] = token
        req.body = { method: 'getDeviceList' }.to_json
      end
      @device_list = parse_response(response)['deviceList']
    end

    def send_data(device, data)
      conn = data_connection(device)
      conn.post do |req|
        req.body = { method: 'passthrough',
                     params: { deviceId: device.id,
                               requestData: data.to_json } }.to_json
      end
    end

    private

    def data_connection(device)
      Faraday.new(device.url) do |c|
        c.request :json
        c.response :json, content_type: /\bjson$/i
        c.adapter Faraday.default_adapter
        # c.params.merge!(DEFAULT_PARAMS)
        c.params['token'] = token
        c.headers.merge!(DEFAULT_HEADERS)
      end
    end

    def parse_response(res)
      raise TPLinkCloudError, 'Generic TPLinkCloud Error' unless res.success?
      response = JSON.parse(res.body)
      raise TPLinkCloudError, 'TPLinkCloud API Error' \
        unless res.body['error'].to_i.zero?
      response['result']
    end
  end
end
