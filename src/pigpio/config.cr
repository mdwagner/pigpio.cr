module Pigpio
  enum ConfigPeripheral
    Pwm
    Pcm
  end

  enum ConfigInterface
    DisableFifo   = LibPigpio::PI_DISABLE_FIFO_IF
    DisableSock   = LibPigpio::PI_DISABLE_SOCK_IF
    LocalhostSock = LibPigpio::PI_LOCALHOST_SOCK_IF
  end

  record Config,
    buffer_size_milliseconds : UInt16? = nil,
    clock_microseconds : UInt8? = nil,
    clock_peripheral : ConfigPeripheral = :pcm,
    dma_primary_channel : UInt8? = nil,
    dma_secondary_channel : UInt8? = nil,
    permissions_update_mask : UInt64? = nil,
    socket_port : UInt16? = nil,
    interface_flag : ConfigInterface? = nil,
    mem_alloc_mode : UInt8? = nil
end
