# frozen_string_literal: true

# Provides errors raised by the gem.

# Handle Errrors related to TPLink's Cloud
class TPLinkCloudError < StandardError
  attr_reader :action
  def initialize(message, action)
    super(message)
    @action = action
  end
end
