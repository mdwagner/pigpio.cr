module Pigpio
  enum ConfigPeripheral
    Pwm = LibPigpio::PI_CLOCK_PWM
    Pcm = LibPigpio::PI_CLOCK_PCM
  end

  enum ConfigInterface
    Default
    DisablePipe         = LibPigpio::PI_DISABLE_FIFO_IF
    DisableSocket       = LibPigpio::PI_DISABLE_SOCK_IF
    DisableRemoteSocket = LibPigpio::PI_LOCALHOST_SOCK_IF
  end

  enum ConfigMemAlloc
    Auto    = LibPigpio::PI_MEM_ALLOC_AUTO
    Pagemap = LibPigpio::PI_MEM_ALLOC_PAGEMAP
    Mailbox = LibPigpio::PI_MEM_ALLOC_MAILBOX
  end

  class Config
    property buffer_millis = LibPigpio::PI_DEFAULT_BUFFER_MILLIS
    property clk_micros = LibPigpio::PI_DEFAULT_CLK_MICROS
    property clk_peripheral : ConfigPeripheral = :pcm
    property dma_primary_channel = LibPigpio::PI_DEFAULT_DMA_PRIMARY_CHANNEL
    property dma_secondary_channel = LibPigpio::PI_DEFAULT_DMA_SECONDARY_CHANNEL
    property update_mask : UInt64? = nil
    property socket_port = LibPigpio::PI_DEFAULT_SOCKET_PORT
    property interface_flag : ConfigInterface = :default
    property mem_alloc_mode : ConfigMemAlloc = :auto
  end
end
