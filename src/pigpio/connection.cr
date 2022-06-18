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
    In   = LibPigpio::PI_INPUT
    Out  = LibPigpio::PI_OUTPUT
    Alt0 = LibPigpio::PI_ALT0
    Alt1 = LibPigpio::PI_ALT1
    Alt2 = LibPigpio::PI_ALT2
    Alt3 = LibPigpio::PI_ALT3
    Alt4 = LibPigpio::PI_ALT4
    Alt5 = LibPigpio::PI_ALT5
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

    def set_mode(gpio, mode : GpioMode) : Nil
      case LibPigpio.gpio_set_mode(gpio, mode.value)
      when LibPigpio::PI_BAD_GPIO
        raise "Bad GPIO pin"
      when LibPigpio::PI_BAD_MODE
        raise "Bad GPIO mode"
      end
    end

    def get_mode(gpio) : GpioMode
      case r = LibPigpio.gpio_get_mode(gpio)
      when LibPigpio::PI_BAD_GPIO
        raise "Bad GPIO pin"
      else
        GpioMode.new(r)
      end
    end

    def set_pull_up_down(gpio, pud : GpioPud) : Nil
      case LibPigpio.gpio_set_pull_up_down(gpio, pud.value)
      when LibPigpio::PI_BAD_GPIO
        raise "Bad GPIO pin"
      when LibPigpio::PI_BAD_PUD
        raise "Bad GPIO pull up/down"
      end
    end

    def read(gpio) : GpioLevel
      case r = LibPigpio.gpio_read(gpio)
      when LibPigpio::PI_BAD_GPIO
        raise "Bad GPIO pin"
      else
        GpioLevel.new(r)
      end
    end

    def write(gpio, level : GpioLevel) : Nil
      case LibPigpio.gpio_write(gpio, level.value)
      when LibPigpio::PI_BAD_GPIO
        raise "Bad GPIO pin"
      when LibPigpio::PI_BAD_LEVEL
        raise "Bad GPIO level"
      end
    end

    def pwm(gpio, dutycycle) : Nil
      case LibPigpio.gpio_pwm(gpio, dutycycle)
      when LibPigpio::PI_BAD_USER_GPIO
        raise "Bad GPIO"
      when LibPigpio::PI_BAD_DUTYCYCLE
        raise "Bad Dutycycle"
      end
    end

    def get_pwm_dutycycle(gpio)
      case r = LibPigpio.gpio_get_pwm_dutycycle(gpio)
      when LibPigpio::PI_BAD_USER_GPIO
        raise "Bad GPIO"
      when LibPigpio::PI_NOT_PWM_GPIO
        raise "Not PWM GPIO"
      else
        r
      end
    end

    def set_pwm_range(gpio, range)
      case r = LibPigpio.gpio_set_pwm_range(gpio, range)
      when LibPigpio::PI_BAD_USER_GPIO
        raise "Bad GPIO"
      when LibPigpio::PI_BAD_DUTYRANGE
        raise "Bad Dutyrange"
      else
        r
      end
    end

    def get_pwm_range(gpio)
      case r = LibPigpio.gpio_get_pwm_range
      when LibPigpio::PI_BAD_USER_GPIO
        raise "Bad GPIO"
      else
        r
      end
    end

    def get_pwm_real_range(gpio)
      case r = LibPigpio.gpio_get_pwm_real_range(gpio)
      when LibPigpio::PI_BAD_USER_GPIO
        raise "Bad GPIO"
      else
        r
      end
    end

    def set_pwm_freq(gpio, freq)
      case r = LibPigpio.gpio_set_pwm_freq(gpio, freq)
      when LibPigpio::PI_BAD_USER_GPIO
        raise "Bad GPIO"
      else
        r
      end
    end

    def get_pwm_freq(gpio)
      case r = LibPigpio.gpio_get_pwm_freq(gpio)
      when LibPigpio::PI_BAD_USER_GPIO
        raise "Bad GPIO"
      else
        r
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

    def cancel_alert(pin)
      LibPigpio.gpio_set_alert_func(pin, nil)
    end
  end
end
