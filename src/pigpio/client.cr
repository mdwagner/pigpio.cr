module Pigpio
  class Client
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
      if @config.buffer_size_milliseconds
        LibPigpio.gpio_cfg_buffer_size(@config.buffer_size_milliseconds)
      end

      if @config.clock_microseconds
        LibPigpio.gpio_cfg_clock(@config.clock_microseconds, @config.clock_peripheral.value, 0)
      end

      if @config.dma_primary_channel && @config.dma_secondary_channel
        LibPigpio.gpio_cfg_dma_channels(@config.dma_primary_channel, @config.dma_secondary_channel)
      end

      if @config.permissions_update_mask
        LibPigpio.gpio_cfg_permissions(@config.permissions_update_mask)
      end

      if @config.socket_port
        LibPigpio.gpio_cfg_socket_port(@config.socket_port)
      end

      if @config.interface_flag
        LibPigpio.gpio_cfg_interfaces(@config.interface_flag.value)
      end

      if @config.mem_alloc_mode
        LibPigpio.gpio_cfg_mem_alloc(@config.mem_alloc_mode)
      end
    end
  end
end
