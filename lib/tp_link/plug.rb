# frozen_string_literal: true

module TPLink
  # Control TPLink Smart Plugs
  class Plug < TPLink::Device
    # Turn device on
    def on
      set_relay_state(1)
    end

    # Turn device off
    def off
      set_relay_state(0)
    end

    # Toggle device (turn off if on, on if off)
    def toggle
      if on?
        off
      else
        on
      end
    end

    private
    def set_relay_state(s)
      @parent.send_data(self,{"system":{"set_relay_state":{"state": s }}})
    end
  end
end
