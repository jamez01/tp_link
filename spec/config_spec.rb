# frozen_string_literal: true
require 'spec_helper.rb'

require_relative '../lib/tp_link.rb'

RSpec.describe TPLink::Config do

  subject do
    described_class.new({
                         'user' => 'test@example.com',
                         'password' => 'password123'
      })
  end

  it "#initialize" do
    expect(subject).to be_a(TPLink::Config)
  end

  it "#to_hash" do
    expect(subject.to_hash).to include(appType: 'Kasa_Android')
    expect(subject.to_hash).to include(cloudUserName: 'test@example.com')
    expect(subject.to_hash).to include(cloudPassword: 'password123' )
    expect(subject.to_hash).to include(:terminalUUID)
  end

end
