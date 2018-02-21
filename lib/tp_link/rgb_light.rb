# frozen_string_literal: true

module TPLink
  # Control TP-Link LS130 / RGB lights
  class RGBLight < TPLink::Device
    # Turn Light on
    def on(b = 100, h = 100, s = 100)
      transition_light_state(1, b, h, s)
    end

    # Turn light off
    def off
      transition_light_state(0, 100, 100, 100)
    end

    private

    def transition_light_state(o, b, h, s)
      @parent.send_data(self,
                        "smartlife.iot.smartbulb.lightingservice": {
                          "transition_light_state": {
                            "on_off": o,
                            "brightness": b,
                            "hue": h,
                            "saturation": s
                          }
                        })
    end
  end
end
