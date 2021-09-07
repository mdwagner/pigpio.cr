module Pigpio
  alias OnAlertFn = LibPigpio::GpioAlertFuncT
  alias OnEventFn = LibPigpio::EventFuncT
  alias OnISRFn = LibPigpio::GpioISRFuncT
  alias OnTimerFn = LibPigpio::GpioTimerFuncT
  alias OnSignalFn = LibPigpio::GpioSignalFuncT
  alias OnGetSamplesFn = LibPigpio::GpioGetSamplesFuncT

  enum GpioMode
    In    = LibPigpio::PI_INPUT
    Out   = LibPigpio::PI_OUTPUT
    Alto0 = LibPigpio::PI_ALTO0
    Alto1 = LibPigpio::PI_ALTO1
    Alto2 = LibPigpio::PI_ALTO2
    Alto3 = LibPigpio::PI_ALTO3
    Alto4 = LibPigpio::PI_ALTO4
    Alto5 = LibPigpio::PI_ALTO5
  end

  class Connection
    @@alert_box : Void*?

    def set_mode!(gpio, mode : GpioMode)
      case LibPigpio.gpio_set_mode(gpio, mode.value)
      when LibPigpio::PI_BAD_GPIO
        raise "Bad GPIO Pin"
      when LibPigpio::PI_BAD_MODE
        raise "Bad GPIO Mode"
      else
        nil
      end
    end

    def set_mode(gpio, mode : GpioMode)
      set_mode!(gpio, mode)
    rescue
      nil
    end

    def on_alert(pin, &block : OnAlertFn)
      if block.closure?
        box = Box(typeof(block)).box(block)
        @@alert_box = box

        f = LibPigpio::GpioAlertFuncExT.new do |gpio, level, tick, userdata|
          Box(typeof(block)).unbox(userdata).call(gpio, level, tick)
        end

        LibPigpio.gpio_set_alert_func_ex(pin, f, box)
      else
        LibPigpio.gpio_set_alert_func(pin, block)
      end
    end
  end
end
