module Pigpio
  class Client
    getter config = Config.new

    def start : Int32
      configure
      LibPigpio.gpio_init
    end

    def stop : Nil
      LibPigpio.gpio_terminate
    end

    def connect(& : Connection ->)
      raise "Initialization failed" if start == LibPigpio::PI_INIT_FAILED
      yield connection ensure stop
    end

    def gpio_version : UInt32
      LibPigpio.gpio_version
    end

    def gpio_hardware_revision : UInt32
      LibPigpio.gpio_hardware_revision
    end

    def connection : Connection
      Connection.new
    end

    def reset_config : Nil
      @config = Config.new
    end

    private def configure
      LibPigpio.gpio_cfg_buffer_size(@config.buffer_millis)
      LibPigpio.gpio_cfg_clock(@config.clk_micros, @config.clk_peripheral.value, 0)
      LibPigpio.gpio_cfg_socket_port(@config.socket_port)
      LibPigpio.gpio_cfg_interfaces(@config.interface_flag.value)
      LibPigpio.gpio_cfg_mem_alloc(@config.mem_alloc_mode.value)

      if @config.update_mask
        LibPigpio.gpio_cfg_permissions(@config.update_mask.not_nil!)
      end

      if @config.dma_primary_channel && @config.dma_secondary_channel
        LibPigpio.gpio_cfg_dma_channels(@config.dma_primary_channel.not_nil!, @config.dma_secondary_channel.not_nil!)
      end
    end
  end
end
