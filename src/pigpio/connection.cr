module Pigpio
  alias OnAlertCallback = LibPigpio::GpioAlertFuncT
  alias OnEventCallback = LibPigpio::EventFuncT
  alias OnISRCallback = LibPigpio::GpioISRFuncT
  alias OnTimerCallback = LibPigpio::GpioTimerFuncT
  alias OnSignalCallback = LibPigpio::GpioSignalFuncT
  alias OnGetSamplesCallback = LibPigpio::GpioGetSamplesFuncT
  alias CustomCallback1 = LibPigpio::GpioCustom1
  alias CustomCallback2 = LibPigpio::GpioCustom2

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

  enum GpioPud
    Off  = LibPigpio::PI_PUD_OFF
    Down = LibPigpio::PI_PUD_DOWN
    Up   = LibPigpio::PI_PUD_UP
  end

  enum GpioLevel
    Low  = LibPigpio::PI_LOW
    High = LibPigpio::PI_HIGH
  end

  class Connection
    @@alert_box : Void*?

    def set_mode(gpio, mode : GpioMode)
      case LibPigpio.gpio_set_mode(gpio, mode.value)
      when LibPigpio::PI_BAD_GPIO
        raise "Bad GPIO pin"
      when LibPigpio::PI_BAD_MODE
        raise "Bad GPIO mode"
      end
    end

    def get_mode(gpio)
      result = LibPigpio.gpio_get_mode(gpio)

      case result
      when LibPigpio::PI_BAD_GPIO
        raise "Bad GPIO pin"
      else
        GpioMode.new(result)
      end
    end

    def set_pull_up_down(gpio, pud : GpioPud)
      case LibPigpio.gpio_set_pull_up_down(gpio, pud.value)
      when LibPigpio::PI_BAD_GPIO
        raise "Bad GPIO pin"
      when LibPigpio::PI_BAD_PUD
        raise "Bad GPIO pull up/down"
      end
    end

    def read(gpio)
      result = LibPigpio.gpio_read(gpio)

      case result
      when LibPigpio::PI_BAD_GPIO
        raise "Bad GPIO pin"
      else
        GpioLevel.new(result)
      end
    end

    def write(gpio, level : GpioLevel)
      case LibPigpio.gpio_write(gpio, level.value)
      when LibPigpio::PI_BAD_GPIO
        raise "Bad GPIO pin"
      when LibPigpio::PI_BAD_LEVEL
        raise "Bad GPIO level"
      end
    end

    def on_alert(pin, &block : OnAlertCallback)
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
