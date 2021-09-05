class PigpioClient
  alias VERSION = Pigpio::VERSION
  alias LibPigpio = Pigpio::LibPigpio

  # TODO
  class Config
    def buffer_size(*args, **options)
      LibPigpio.gpio_cfg_buffer_size(*args, **options)
    end

    def clock(*args, **options)
      LibPigpio.gpio_cfg_clock(*args, **options)
    end

    def dma_channels(*args, **options)
      LibPigpio.gpio_cfg_dma_channels(*args, **options)
    end

    def permissions(*args, **options)
      LibPigpio.gpio_cfg_permissions(*args, **options)
    end

    def interfaces(*args, **options)
      LibPigpio.gpio_cfg_interfaces(*args, **options)
    end

    def socket_port(*args, **options)
      LibPigpio.gpio_cfg_socket_port(*args, **options)
    end

    def mem_alloc(*args, **options)
      LibPigpio.gpio_cfg_mem_alloc(*args, **options)
    end
  end

  property config : Config

  def initialize(@config)
  end

  def start
    configure
    LibPigpio.gpio_init
  end

  def stop
    LibPigpio.gpio_terminate
  end

  def connect
    raise "Initialization failed" if start < 0
    yield connection ensure stop
  end

  def gpio_version
    LibPigpio.gpio_version
  end

  def gpio_hardware_revision
    LibPigpio.gpio_hardware_revision
  end

  def connection
    Connection.new
  end

  private def configure
    # TODO: run @config methods
  end

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
