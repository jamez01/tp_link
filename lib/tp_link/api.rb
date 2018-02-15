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
    c.adapter Faraday.default_adapter
    c.params['appName'] = "Kasa_Android"
    c.params['termID']  = Proc.new { @config.terminal_uuid }
    c.params['appVer'] = '1.4.4.607'
    c.params['ospf'] = 'Android+6.0.1'
    c.params['netType'] = 'wifi'
    c.params['locale'] =  'es_ES'
    c.headers['Connection'] = 'Keep-Alive'
    c.headers['User-Agent'] = 'Dalvik/2.1.0 (Linux; U; Android 6.0.1; A0001 Build/M4B30X)'
    c.headers['Content-Type'] = "applicatoin/json;charset=utf-8"
    c.headers['Accept'] = "application/json, text/plain, */*"

  end

  class API
    DEFAULT_OPTIONS = {
      config: "#{ENV['HOME']}/.tp_link"
    }.freeze
    def initialize(opts = {})
      options = DEFAULT_OPTIONS.merge(opts)
      @config = Config.new(options[:config])
    end


    def get_token
      response=TOKEN_API.post do |req|
        req.url '/'
        req.body = {method:"login",url:"https://wap.tplinkcloud.com",params: @config.to_hash}.to_json
      end
      parse_response(response)['token']
    end

    private
    
    def parse_response(res)
      raise TPLinkCloudError.new("Generic TPLinkCloud Error") unless res.success?
      response = JSON.parse(res.body)
      raise TPLinkCloudError.new("TPLinkCloud API Error") unless res.body['error'].to_i == 0
      return response['result']
    end

  end
end
