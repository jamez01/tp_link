
# frozen_string_literal: true

require 'spec_helper.rb'

require_relative '../lib/tp_link.rb'

RSpec.describe TPLink::Light do
  let(:smarthome) do
    TPLink::SmartHome.new('user' => 'test@example.com', 'password' => 'password123')
  end
  let(:devices) do
    [{ 'alias' => 'test device',
       'deviceType' => 'IOT.SMARTBULB',
       'deviceModel' => 'LB100 (US)',
       'deviceId' => '100' }]
  end

  subject do
    described_class.new(smarthome, {})
  end

  it '#on' do
    allow_any_instance_of(TPLink::API).to receive(:device_list).and_return(devices)
    allow_any_instance_of(TPLink::Light).to receive(:reload).and_return(true)
    allow_any_instance_of(TPLink::SmartHome).to receive(:send_data).and_return(true)
    expect(subject.on).to eql(true)
  end

  it '#off' do
    allow_any_instance_of(TPLink::API).to receive(:device_list).and_return(devices)
    allow_any_instance_of(TPLink::SmartHome).to receive(:send_data).and_return(true)
    expect(subject.off).to eql(true)
  end

  it '#toggle' do
    allow_any_instance_of(TPLink::API).to receive(:device_list).and_return(devices)
    expect(subject).to respond_to(:toggle)
  end

  it '#transition_light_state' do
    allow_any_instance_of(TPLink::API).to receive(:device_list).and_return(devices)
    allow_any_instance_of(TPLink::Device).to receive(:reload).and_return(true)
    expect(smarthome).to receive(:send_data).and_return(true)
    expect(smarthome).to receive(:send_data).and_return(true)
    expect(subject.on).to eql(true)
  end
end
