class TPLinkCloudError < StandardError
  attr_reader :action

  def initialize(message, action)
    super(message)
    @action = action
  end

end
