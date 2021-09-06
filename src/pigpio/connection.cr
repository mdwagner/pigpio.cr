module Pigpio
  class Connection
    @@alert_box : Void*?

    def on_alert(pin, &block : LibPigpio::GpioAlertFuncT)
      if block.closure?
        box = Box(typeof(block)).box(block)
        @@alert_box = box

        f = GpioAlertFuncExT.new do |gpio, level, tick, userdata|
          Box(typeof(block)).unbox(userdata).call(gpio, level, tick)
        end

        LibPigpio.gpio_set_alert_func_ex(pin, f, box)
      else
        LibPigpio.gpio_set_alert_func(pin, block)
      end
    end
  end
end
