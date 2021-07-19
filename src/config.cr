module Pigpio
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
end
