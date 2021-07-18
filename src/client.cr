module Pigpio
  class Client
    def self.instance
      @@instance ||= new
    end

    private def initialize
    end

    alias AlertBox = Box(LibPigpio::GpioAlertFuncT)
    @@alert_box : Void*?

    def run(&block : Int32 ->) : Void
      version = LibPigpio.gpio_init
      with self yield version
      LibPigpio.gpio_terminate if version > 0
    end

    private def on_alert(pin, &block : LibPigpio::GpioAlertFuncT)
      if block.closure?
        box = AlertBox.box(block)
        @@alert_box = box

        f = GpioAlertFuncExT.new do |gpio, level, tick, userdata|
          AlertBox.unbox(userdata).call(gpio, level, tick)
        end

        LibPigpio.gpio_set_alert_func_ex(pin, f, box)
      else
        LibPigpio.gpio_set_alert_func(pin, block)
      end
    end
  end
end
