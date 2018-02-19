# frozen_string_literal: true

module TPLink
  # Control TPLink Dimmable lights
  # @example
  #  light.on # turn on light
  #  light.off # turn off light
  #
  #  # turn on light and set brightness to 50%
  #  light.on
  #  light.on(50)
  class Light < TPLink::Device

    # Turn light on
    # @param b [Integer<1-100>] Set light intensity between 1 and 100
    def on(b = 100)
      transition_light_state(1, b)
    end

    # Turn light off
    def off
      transition_light_state(0, 100)
    end

    private

    def transition_light_state(o, b)
      @parent.send_data(self,
                            "smartlife.iot.smartbulb.lightingservice": {
                              "transition_light_state": {
                                "on_off": o,
                                "brightness": b
                              }
                            })
    end
  end
end
