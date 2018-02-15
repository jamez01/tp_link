# frozen_string_literal: true
module TPLink
  # Communicate with the tplink cloud api
  TOKEN_API = Faraday.new('https://wap.tplinkcloud.com') do |c|
    # c.use FaradayMiddleware::ParseJson,       content_type: 'application/json'
    # c.use Faraday::Response::Logger,          Logger.new('faraday.log')
    # c.use FaradayMiddleware::FollowRedirects, limit: 31
    # raise exceptions on 40x, 50x responses
    # c.use Faraday::Response::RaiseError
    # c.use Faraday::Adapter::NetHttp
    c.request :json

    c.response :json, :content_type => /\bjson$/
    c.use :instrumentation
    c.adapter Faraday.default_adapter

  end

  class API
    DEFAULT_OPTIONS = {
      config: "#{ENV['HOME']}/.tp_link"
    }.freeze
    def initialize(opts = {})
      options = DEFAULT_OPTIONS.merge(opts)
      @config = Config.new(options[:config])
    end

    def auth
      response=TOKEN_API.post do |req|
        req.url '/'
        req.params['appName'] = "Kasa_Android"
        req.params['termID']  = @config.terminal_uuid
        req.params['appVer'] = '1.4.4.607'
        req.params['ospf'] = 'Android+6.0.1'
        req.params['netType'] = 'wifi'
        req.params['locale'] =  'es_ES'
        req.headers['Connection'] = 'Keep-Alive'
        req.headers['User-Agent'] = 'Dalvik/2.1.0 (Linux; U; Android 6.0.1; A0001 Build/M4B30X)'
        req.headers['Content-Type'] = "applicatoin/json;charset=utf-8"
        req.headers['Accept'] = "application/json, text/plain, */*"
        req.body = {method:"login",url:"https://wap.tplinkcloud.com",params: @config.to_hash}.to_json
      end
      JSON.parse(response.body)['result']['token'] if response.success?
    end
  end
end
