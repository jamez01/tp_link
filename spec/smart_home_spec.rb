# frozen_string_literal: true

require 'spec_helper.rb'

require_relative '../lib/tp_link.rb'

RSpec.describe TPLink::SmartHome do
  subject do
    described_class.new('user' => 'test@example.com', 'password' => 'password123')
  end

  let(:devices) do
    [{ 'alias' => 'test device',
       'deviceType' => 'IOT.SMARTBULB',
       'deviceModel' => 'LB100 (US)',
       'deviceId' => '100' }]
  end

  it '#devices' do
    allow_any_instance_of(TPLink::API).to receive(:token).and_return(true)
    allow_any_instance_of(TPLink::API).to receive(:device_list).and_return(devices)

    expect(subject.devices).to be_a(Array)
    expect(subject.devices.count).to eql(1)
  end

  it '#find' do
    allow_any_instance_of(TPLink::API).to receive(:device_list).and_return(devices)
    expect(subject.find('alias')).to eql(nil)
    expect(subject.find('test device')).to be_a(TPLink::Light)
  end

  it '#send_data' do
    allow_any_instance_of(TPLink::API).to receive(:token).and_return(true)
    allow_any_instance_of(TPLink::API).to receive(:device_list).and_return(devices)
    allow_any_instance_of(TPLink::API).to receive(:send_data).and_return(true)
    expect(subject.send_data(subject, [])).to eql(true)
  end
end
