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

  record Config,
    buffer_millis = LibPigpio::PI_DEFAULT_BUFFER_MILLIS,
    clk_micros = LibPigpio::PI_DEFAULT_CLK_MICROS,
    clk_peripheral : ConfigPeripheral = :pcm,
    dma_primary_channel = LibPigpio::PI_DEFAULT_DMA_PRIMARY_CHANNEL,
    dma_secondary_channel = LibPigpio::PI_DEFAULT_DMA_SECONDARY_CHANNEL,
    update_mask : UInt64? = nil,
    socket_port = LibPigpio::PI_DEFAULT_SOCKET_PORT,
    interface_flag : ConfigInterface = :default,
    mem_alloc_mode : ConfigMemAlloc = :auto
end
