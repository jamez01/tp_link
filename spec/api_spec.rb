# frozen_string_literal: true

require 'spec_helper.rb'
require 'webmock/rspec'

require_relative '../lib/tp_link.rb'

RSpec.describe TPLink::API do
  let(:uuid) { "21a91585-6dcb-4f04-82c7-ac18eb5bd18c" }
  let(:stub_login) {
    allow_any_instance_of(Faraday::Connection).to receive(:post).and_return(
      double("response", status: 200, body: {"result" => {"token" => "ToKeN"}}, success?: true)
    )
    # stub_request(:post, "https://wap.tplinkcloud.com/").
    # with(
    # query: hash_including("appName" => "Kasa_Android"),
    # body: "{\"method\":\"login\",\"url\":\"https://wap.tplinkcloud.com\",\"params\":{\"appType\":\"Kasa_Android\",\"cloudUserName\":\"test@example.com\",\"cloudPassword\":\"password123\",\"terminalUUID\":\"#{uuid}\"}}",
    # headers: {
    #   'Accept'=>'application/json, text/plain, */*',
    #   'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
    #   'Connection'=>'Keep-Alive',
    #   'User-Agent'=>'Dalvik/2.1.0 (Linux; U; Android 6.0.1; A0001 Build/M4B30X)'
    #   'Content-Type'=>'applicatoin/json;charset=utf-8',
    #   }).
    #   to_return(status: 200, body: {"result":{"token":"ToKeN"}}, headers: {})
    }
    let(:device_double) {
      double(url: "https://example.com",id: "1234")
    }
    let(:config) {
      {
        'user' => 'test@example.com',
        'password' => 'password123',
        'uuid' => uuid
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
      allow_any_instance_of(Faraday::Connection).to receive(:post).and_return(
        double("response", status: 200, body: {"result" => {"deviceList" => []}}, success?: true)
      )
      expect(subject.device_list).to eql([])
    end

      it "#send_data" do
        stub_login
        allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(
          double("response", status: 200, body: {})
        )
          expect(subject.send_data(device_double, {'response' => []})).to be_truthy
        end
      end
