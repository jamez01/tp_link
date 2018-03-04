# frozen_string_literal: true

require 'spec_helper.rb'
require 'webmock/rspec'

require_relative '../lib/tp_link.rb'

RSpec.describe TPLink::API do
  let(:stub_login) {
    stub_request(:post, "https://wap.tplinkcloud.com/").
      with(
      query: hash_including("appName" => "Kasa_Android"),
        body: "{\"method\":\"login\",\"url\":\"https://wap.tplinkcloud.com\",\"params\":{\"appType\":\"Kasa_Android\",\"cloudUserName\":\"test@example.com\",\"cloudPassword\":\"password123\",\"terminalUUID\":null}}",
        headers: {
       'Accept'=>'application/json, text/plain, */*',
       'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       'Connection'=>'Keep-Alive',
       'Content-Type'=>'applicatoin/json;charset=utf-8',
       'User-Agent'=>'Dalvik/2.1.0 (Linux; U; Android 6.0.1; A0001 Build/M4B30X)'
        }).
      to_return(status: 200, body: '{"result":{"token":"ToKeN"}}', headers: {})
  }
  let(:device_double) {
    double(url: "https://example.com",id: "1234")
  }
  let(:config) {
    {
      config: {
        'user' => 'test@example.com',
        'password' => 'password123'
      }
    }
  }
  subject do
    described_class.new(config)
  end

  it "#token" do
    stub_login
    expect(subject.token).to eql('ToKeN')
  end

    it "#device_list" do
      stub_login
      stub_request(:post, "https://wap.tplinkcloud.com/").
        with(
        query: hash_including("appName" => "Kasa_Android"),
          body: "{\"method\":\"getDeviceList\"}",
          headers: {
         'Accept'=>'application/json, text/plain, */*',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'Connection'=>'Keep-Alive',
         'Content-Type'=>'applicatoin/json;charset=utf-8',
         'User-Agent'=>'Dalvik/2.1.0 (Linux; U; Android 6.0.1; A0001 Build/M4B30X)'
          }).
        to_return(status: 200, body: '{"result":{"deviceList":[]}}', headers: {})
      expect(subject.device_list).to eql([])
    end

    it "#send_data" do
      stub_login
      stub_request(:post, "https://example.com/?token=ToKeN").
         with(
           body: "{\"method\":\"passthrough\",\"params\":{\"deviceId\":\"1234\",\"requestData\":\"{}\"}}",
           headers: {
       	  'Accept'=>'application/json, text/plain, */*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'Connection'=>'Keep-Alive',
       	  'Content-Type'=>'applicatoin/json;charset=utf-8',
       	  'User-Agent'=>'Dalvik/2.1.0 (Linux; U; Android 6.0.1; A0001 Build/M4B30X)'
           }).
         to_return(status: 200, body: '{"result":{"":[]}}', headers: {})
      expect(subject.send_data(device_double, {})).to be_truthy
    end
  end
