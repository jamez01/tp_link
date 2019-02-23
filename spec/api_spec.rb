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
