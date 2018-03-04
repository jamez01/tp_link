# frozen_string_literal: true

require 'spec_helper.rb'

require_relative '../lib/tp_link.rb'

RSpec.describe TPLink::Device do
  let(:response_data) do
    {
      'responseData' => {
        'system' => {
            'get_sysinfo' => { 'rssi' => -1 }
        }
      }
    }
  end
  let(:smarthome) do
    double(TPLink::SmartHome, :send_data => response_data)
  end


  subject do
    described_class.new(smarthome, 'alias' => 'test device',
                                   'deviceName' => 'test device name',
                                   'status' => 0,
                                   'deviceType' => 'Test device',
                                   'appServerUrl' => 'http://example.com/',
                                   'deviceModel' => '0',
                                   'deviceMac' => 'BD:DB:4B:93:16:CB',
                                   'role' => 'testing',
                                   'isSameRegion' => true,
                                   'hwId' => 'eimuukup4eiSh9a',
                                   'fwId' => 'ohR0ke2fahngo4o',
                                   'deviceId' => 'lingeifohph6aeY',
                                   'deviceHwVersion' => '0.0.0',
                                   'fwVer' => '0.0.0')
  end

  it "has expected attributes" do
    expect(subject).to have_attributes(alias: 'test device',
                                       name: 'test device name',
                                       type: 'Test device',
                                       url: 'http://example.com/',
                                       model: '0',
                                       mac: 'BD:DB:4B:93:16:CB',
                                       role: 'testing',
                                       same_region: true,
                                       hw_id: 'eimuukup4eiSh9a',
                                       fw_id: 'ohR0ke2fahngo4o',
                                       id: 'lingeifohph6aeY',
                                       hw_version: '0.0.0',
                                       fw_version: '0.0.0')
  end

  it "#on" do
    expect(subject).to respond_to(:on)
    expect(subject.on).to eql(nil)
  end

  it "#off" do
    expect(subject).to respond_to(:off)
    expect(subject.off).to eql(nil)
  end

  it "#on?" do
    expect(subject.on?).not_to be_truthy
  end

  it "#off?" do
    expect(subject.off?).to be_truthy
  end

  it "#rssi" do
    expect(subject.rssi).to eql(-1)
  end

end
