module Pigpio
  # https://abyz.me.uk/rpi/pigpio/cif.html
  @[Link("pigpio")]
  lib LibPigpio
    alias Int = LibC::Int
    alias Int32T = LibC::Int32T
    alias UInt = LibC::UInt
    alias UInt8T = LibC::UInt8T
    alias UInt16T = LibC::UInt16T
    alias UInt32T = LibC::UInt32T
    alias UInt64T = LibC::UInt64T

    # Constants
    BSC_FIFO_SIZE              =         512
    PI_OFF                     =           0
    PI_ON                      =           1
    PI_CLEAR                   =           0
    PI_SET                     =           1
    PI_LOW                     =           0
    PI_HIGH                    =           1
    PI_TIMEOUT                 =           2
    PI_INPUT                   =           0
    PI_OUTPUT                  =           1
    PI_ALT0                    =           4
    PI_ALT1                    =           5
    PI_ALT2                    =           6
    PI_ALT3                    =           7
    PI_ALT4                    =           3
    PI_ALT5                    =           2
    PI_PUD_OFF                 =           0
    PI_PUD_DOWN                =           1
    PI_PUD_UP                  =           2
    PI_MIN_DUTYCYCLE_RANGE     =          25
    PI_MAX_DUTYCYCLE_RANGE     =      40_000
    PI_SERVO_OFF               =           0
    PI_MIN_SERVO_PULSEWIDTH    =         500
    PI_MAX_SERVO_PULSEWIDTH    =       2_500
    PI_HW_PWM_MIN_FREQ         =           1
    PI_HW_PWM_MAX_FREQ         = 125_000_000
    PI_HW_PWM_RANGE            =   1_000_000
    PI_HW_CLK_MIN_FREQ         =       4_689
    PI_HW_CLK_MIN_FREQ_2711    =      13_184
    PI_HW_CLK_MAX_FREQ         = 250_000_000
    PI_HW_CLK_MAX_FREQ_2711    = 375_000_000
    PI_NTFY_FLAGS_EVENT        = 1 << 7
    PI_NTFY_FLAGS_ALIVE        = 1 << 6
    PI_NTFY_FLAGS_WDOG         = 1 << 5
    PI_BB_SER_NORMAL           =      0
    PI_BB_SER_INVERT           =      1
    PI_MIN_WAVE_DATABITS       =      1
    PI_MAX_WAVE_DATABITS       =     32
    PI_MIN_WAVE_HALFSTOPBITS   =      2
    PI_MAX_WAVE_HALFSTOPBITS   =      8
    PI_WAVE_MODE_ONE_SHOT      =      0
    PI_WAVE_MODE_REPEAT        =      1
    PI_WAVE_MODE_ONE_SHOT_SYNC =      2
    PI_WAVE_MODE_REPEAT_SYNC   =      3
    PI_WAVE_NOT_FOUND          =  9_998
    PI_NO_TX_WAVE              =  9_999
    PI_MIN_WDOG_TIMEOUT        =      0
    PI_MAX_WDOG_TIMEOUT        = 60_000
    PI_MIN_TIMER               =      0
    PI_MAX_TIMER               =      9
    PI_SCRIPT_INITING          =      0
    PI_SCRIPT_HALTED           =      1
    PI_SCRIPT_RUNNING          =      2
    PI_SCRIPT_WAITING          =      3
    PI_SCRIPT_FAILED           =      4
    PI_MIN_SIGNUM              =      0
    PI_MAX_SIGNUM              =     63
    PI_TIME_RELATIVE           =      0
    PI_TIME_ABSOLUTE           =      1
    PI_CLOCK_PWM               =      0
    PI_CLOCK_PCM               =      1
    PI_MIN_DMA_CHANNEL         =      0
    PI_MAX_DMA_CHANNEL         =     15
    PI_DISABLE_FIFO_IF         =      1
    PI_DISABLE_SOCK_IF         =      2
    PI_LOCALHOST_SOCK_IF       =      4
    PI_DISABLE_ALERT           =      8
    PI_MEM_ALLOC_AUTO          =      0
    PI_MEM_ALLOC_PAGEMAP       =      1
    PI_MEM_ALLOC_MAILBOX       =      2
    PI_CFG_DBG_LEVEL           =      0
    PI_CFG_ALERT_FREQ          =      4
    PI_CFG_RT_PRIORITY         = 1 << 8
    PI_CFG_STATS               = 1 << 9
    PI_CFG_NOSIGHANDLER        = 1 << 10
    PI_CFG_ILLEGAL_VAL         = 1 << 11
    RISING_EDGE                =  0
    FALLING_EDGE               =  1
    EITHER_EDGE                =  2
    PI_FILE_READ               =  1
    PI_FILE_WRITE              =  2
    PI_FILE_RW                 =  3
    PI_FILE_APPEND             =  4
    PI_FILE_CREATE             =  8
    PI_FILE_TRUNC              = 16
    PI_FROM_START              =  0
    PI_FROM_CURRENT            =  1
    PI_FROM_END                =  2
    PI_EVENT_BSC               = 31

    # Error Codes
    PI_INIT_FAILED      =    -1
    PI_BAD_USER_GPIO    =    -2
    PI_BAD_GPIO         =    -3
    PI_BAD_MODE         =    -4
    PI_BAD_LEVEL        =    -5
    PI_BAD_PUD          =    -6
    PI_BAD_PULSEWIDTH   =    -7
    PI_BAD_DUTYCYCLE    =    -8
    PI_BAD_TIMER        =    -9
    PI_BAD_MS           =   -10
    PI_BAD_TIMETYPE     =   -11
    PI_BAD_SECONDS      =   -12
    PI_BAD_MICROS       =   -13
    PI_TIMER_FAILED     =   -14
    PI_BAD_WDOG_TIMEOUT =   -15
    PI_BAD_CLK_PERIPH   =   -17
    PI_BAD_CLK_MICROS   =   -19
    PI_BAD_BUF_MILLIS   =   -20
    PI_BAD_DUTYRANGE    =   -21
    PI_BAD_SIGNUM       =   -22
    PI_BAD_PATHNAME     =   -23
    PI_NO_HANDLE        =   -24
    PI_BAD_HANDLE       =   -25
    PI_BAD_IF_FLAGS     =   -26
    PI_BAD_CHANNEL      =   -27
    PI_BAD_PRIM_CHANNEL =   -27
    PI_BAD_SOCKET_PORT  =   -28
    PI_BAD_FIFO_COMMAND =   -29
    PI_BAD_SECO_CHANNEL =   -30
    PI_NOT_INITIALISED  =   -31
    PI_INITIALISED      =   -32
    PI_BAD_WAVE_MODE    =   -33
    PI_BAD_CFG_INTERNAL =   -34
    PI_BAD_WAVE_BAUD    =   -35
    PI_TOO_MANY_PULSES  =   -36
    PI_TOO_MANY_CHARS   =   -37
    PI_NOT_SERIAL_GPIO  =   -38
    PI_BAD_SERIAL_STRUC =   -39
    PI_BAD_SERIAL_BUF   =   -40
    PI_NOT_PERMITTED    =   -41
    PI_SOME_PERMITTED   =   -42
    PI_BAD_WVSC_COMMND  =   -43
    PI_BAD_WVSM_COMMND  =   -44
    PI_BAD_WVSP_COMMND  =   -45
    PI_BAD_PULSELEN     =   -46
    PI_BAD_SCRIPT       =   -47
    PI_BAD_SCRIPT_ID    =   -48
    PI_BAD_SER_OFFSET   =   -49
    PI_GPIO_IN_USE      =   -50
    PI_BAD_SERIAL_COUNT =   -51
    PI_BAD_PARAM_NUM    =   -52
    PI_DUP_TAG          =   -53
    PI_TOO_MANY_TAGS    =   -54
    PI_BAD_SCRIPT_CMD   =   -55
    PI_BAD_VAR_NUM      =   -56
    PI_NO_SCRIPT_ROOM   =   -57
    PI_NO_MEMORY        =   -58
    PI_SOCK_READ_FAILED =   -59
    PI_SOCK_WRIT_FAILED =   -60
    PI_TOO_MANY_PARAM   =   -61
    PI_SCRIPT_NOT_READY =   -62
    PI_BAD_TAG          =   -63
    PI_BAD_MICS_DELAY   =   -64
    PI_BAD_MILS_DELAY   =   -65
    PI_BAD_WAVE_ID      =   -66
    PI_TOO_MANY_CBS     =   -67
    PI_TOO_MANY_OOL     =   -68
    PI_EMPTY_WAVEFORM   =   -69
    PI_NO_WAVEFORM_ID   =   -70
    PI_I2C_OPEN_FAILED  =   -71
    PI_SER_OPEN_FAILED  =   -72
    PI_SPI_OPEN_FAILED  =   -73
    PI_BAD_I2C_BUS      =   -74
    PI_BAD_I2C_ADDR     =   -75
    PI_BAD_SPI_CHANNEL  =   -76
    PI_BAD_FLAGS        =   -77
    PI_BAD_SPI_SPEED    =   -78
    PI_BAD_SER_DEVICE   =   -79
    PI_BAD_SER_SPEED    =   -80
    PI_BAD_PARAM        =   -81
    PI_I2C_WRITE_FAILED =   -82
    PI_I2C_READ_FAILED  =   -83
    PI_BAD_SPI_COUNT    =   -84
    PI_SER_WRITE_FAILED =   -85
    PI_SER_READ_FAILED  =   -86
    PI_SER_READ_NO_DATA =   -87
    PI_UNKNOWN_COMMAND  =   -88
    PI_SPI_XFER_FAILED  =   -89
    PI_BAD_POINTER      =   -90
    PI_NO_AUX_SPI       =   -91
    PI_NOT_PWM_GPIO     =   -92
    PI_NOT_SERVO_GPIO   =   -93
    PI_NOT_HCLK_GPIO    =   -94
    PI_NOT_HPWM_GPIO    =   -95
    PI_BAD_HPWM_FREQ    =   -96
    PI_BAD_HPWM_DUTY    =   -97
    PI_BAD_HCLK_FREQ    =   -98
    PI_BAD_HCLK_PASS    =   -99
    PI_HPWM_ILLEGAL     =  -100
    PI_BAD_DATABITS     =  -101
    PI_BAD_STOPBITS     =  -102
    PI_MSG_TOOBIG       =  -103
    PI_BAD_MALLOC_MODE  =  -104
    PI_TOO_MANY_SEGS    =  -105
    PI_BAD_I2C_SEG      =  -106
    PI_BAD_SMBUS_CMD    =  -107
    PI_NOT_I2C_GPIO     =  -108
    PI_BAD_I2C_WLEN     =  -109
    PI_BAD_I2C_RLEN     =  -110
    PI_BAD_I2C_CMD      =  -111
    PI_BAD_I2C_BAUD     =  -112
    PI_CHAIN_LOOP_CNT   =  -113
    PI_BAD_CHAIN_LOOP   =  -114
    PI_CHAIN_COUNTER    =  -115
    PI_BAD_CHAIN_CMD    =  -116
    PI_BAD_CHAIN_DELAY  =  -117
    PI_CHAIN_NESTING    =  -118
    PI_CHAIN_TOO_BIG    =  -119
    PI_BAD_SER_INVERT   =  -121
    PI_BAD_EDGE         =  -122
    PI_BAD_ISR_INIT     =  -123
    PI_BAD_FOREVER      =  -124
    PI_BAD_FILTER       =  -125
    PI_BAD_PAD          =  -126
    PI_BAD_STRENGTH     =  -127
    PI_FIL_OPEN_FAILED  =  -128
    PI_BAD_FILE_MODE    =  -129
    PI_BAD_FILE_FLAG    =  -130
    PI_BAD_FILE_READ    =  -131
    PI_BAD_FILE_WRITE   =  -132
    PI_FILE_NOT_ROPEN   =  -133
    PI_FILE_NOT_WOPEN   =  -134
    PI_BAD_FILE_SEEK    =  -135
    PI_NO_FILE_MATCH    =  -136
    PI_NO_FILE_ACCESS   =  -137
    PI_FILE_IS_A_DIR    =  -138
    PI_BAD_SHELL_STATUS =  -139
    PI_BAD_SCRIPT_NAME  =  -140
    PI_BAD_SPI_BAUD     =  -141
    PI_NOT_SPI_GPIO     =  -142
    PI_BAD_EVENT_ID     =  -143
    PI_NOT_ON_BCM2711   =  -145
    PI_ONLY_ON_BCM2711  =  -146
    PI_PIGIF_ERR_0      = -2000
    PI_PIGIF_ERR_99     = -2099
    PI_CUSTOM_ERR_0     = -3000
    PI_CUSTOM_ERR_999   = -3999

    # Defaults
    PI_DEFAULT_BUFFER_MILLIS         = 120
    PI_DEFAULT_CLK_MICROS            =   5
    PI_DEFAULT_CLK_PERIPHERAL        = PI_CLOCK_PCM
    PI_DEFAULT_SOCKET_PORT           = 8888
    PI_DEFAULT_DMA_PRIMARY_CH_2711   =    7
    PI_DEFAULT_DMA_SECONDARY_CH_2711 =    6
    PI_DEFAULT_DMA_PRIMARY_CHANNEL   =   14
    PI_DEFAULT_DMA_SECONDARY_CHANNEL =    6

    # Data structures
    struct GpioHeader
      func, size : UInt16T
    end

    type GpioHeaderT = GpioHeader

    struct GpioExtent
      size : LibC::SizeT
      ptr : Void*
      data : UInt32T
    end

    type GpioExtentT = GpioExtent

    struct GpioSample
      tick, level : UInt32T
    end

    type GpioSampleT = GpioSample

    struct GpioReport
      seqno, flags : UInt16T
      tick, level : UInt32T
    end

    type GpioReportT = GpioReport

    struct GpioPulseT
      gpioOn, gpioOff, usDelay : UInt32T
    end

    struct RawWaveT
      gpioOn, gpioOff, usDelay, flags : UInt32T
    end

    struct RawWaveInfo
      botCB, topCB, botOOL, topOOL, deleted, numCB, numBOOL, numTOOL : UInt16T
    end

    type RawWaveInfoT = RawWaveInfo

    struct RawSpiT
      clk, mosi, miso, ss_pol, ss_us, clk_pol, clk_pha, clk_us : Int
    end

    struct RawCbs
      info, src, dst, length, stride, next : UInt32T
      pad : UInt32T[2]
    end

    type RawCbsT = RawCbs

    struct PiIc2MsgT
      addr, flags, len : UInt16T
      buf : UInt8T*
    end

    struct BscXferT
      control : UInt32T
      rxCnt, txCnt : Int
      rxBuf, txBuf : LibC::Char[BSC_FIFO_SIZE]
    end

    # Procs
    alias GpioAlertFuncT = Int, Int, UInt32T -> Void
    alias GpioAlertFuncExT = Int, Int, UInt32T, Void* -> Void
    alias EventFuncT = Int, UInt32T -> Void
    alias EventFuncExT = Int, UInt32T, Void* -> Void
    alias GpioISRFuncT = Int, Int, UInt32T -> Void
    alias GpioISRFuncExT = Int, Int, UInt32T, Void* -> Void
    alias GpioTimerFuncT = -> Void
    alias GpioTimerFuncExT = Void* -> Void
    alias GpioSignalFuncT = Int -> Void
    alias GpioSignalFuncExT = Int, Void* -> Void
    alias GpioGetSamplesFuncT = GpioSampleT*, Int -> Void
    alias GpioGetSamplesFuncExT = GpioSampleT*, Int, Void* -> Void
    alias GpioThreadFuncT = Void* -> Void*
    alias GpioCustom1 = UInt, UInt, LibC::Char*, UInt -> Int
    alias GpioCustom2 = UInt, LibC::Char*, UInt, LibC::Char*, UInt -> Int

    # Methods
    fun gpio_init = gpioInitialise : Int
    fun gpio_terminate = gpioTerminate : Void
    fun gpio_set_mode = gpioSetMode(gpio : UInt, mode : UInt) : Int
    fun gpio_get_mode = gpioGetMode(gpio : UInt) : Int
    fun gpio_set_pull_up_down = gpioSetPullUpDown(gpio : UInt, pud : UInt) : Int
    fun gpio_read = gpioRead(gpio : UInt) : Int
    fun gpio_write = gpioWrite(gpio : UInt, level : UInt) : Int
    fun gpio_pwm = gpioPWM(user_gpio : UInt, dutycycle : UInt) : Int
    fun gpio_get_pwm_dutycycle = gpioGetPWMdutycycle(user_gpio : UInt) : Int
    fun gpio_set_pwm_range = gpioSetPWMrange(user_gpio : UInt, range : UInt) : Int
    fun gpio_get_pwm_range = gpioGetPWMrange(user_gpio : UInt) : Int
    fun gpio_get_pwm_real_range = gpioGetPWMrealRange(user_gpio : UInt) : Int
    fun gpio_set_pwm_freq = gpioSetPWMfrequency(user_gpio : UInt, frequency : UInt) : Int
    fun gpio_get_pwm_freq = gpioGetPWMfrequency(user_gpio : UInt) : Int
    fun gpio_servo = gpioServo(user_gpio : UInt, pulsewidth : UInt) : Int
    fun gpio_get_servo_pulsewidth = gpioGetServoPulsewidth(user_gpio : UInt) : Int
    fun gpio_set_alert_func = gpioSetAlertFunc(user_gpio : UInt, f : GpioAlertFuncT) : Int
    fun gpio_set_alert_func_ex = gpioSetAlertFuncEx(user_gpio : UInt, f : GpioAlertFuncExT, userdata : Void*) : Int
    fun gpio_set_isr_func = gpioSetISRFunc(gpio : UInt, edge : UInt, timeout : Int, f : GpioISRFuncT) : Int
    fun gpio_set_isr_func_ex = gpioSetISRFuncEx(gpio : UInt, edge : UInt, timeout : Int, f : GpioISRFuncExT, userdata : Void*) : Int
    fun gpio_notify_open = gpioNotifyOpen : Int
    fun gpio_notify_open_with_size = gpioNotifyOpenWithSize(bufSize : Int) : Int
    fun gpio_notify_begin = gpioNotifyBegin(handle : UInt, bits : UInt32T) : Int
    fun gpio_notify_pause = gpioNotifyPause(handle : UInt) : Int
    fun gpio_notify_close = gpioNotifyClose(handle : UInt) : Int
    fun gpio_wave_clear = gpioWaveClear : Int
    fun gpio_wave_add_new = gpioWaveAddNew : Int
    fun gpio_wave_add_generic = gpioWaveAddGeneric(num_pulses : UInt, pulses : GpioPulseT*) : Int
    fun gpio_wave_add_serial = gpioWaveAddSerial(user_gpio : UInt, baud : UInt, data_bits : UInt, stop_bits : UInt, offset : UInt, num_bytes : UInt, str : LibC::Char*) : Int
    fun gpio_wave_create = gpioWaveCreate : Int
    fun gpio_wave_create_pad = gpioWaveCreatePad(pct_cb : Int, pct_bool : Int, pct_tool : Int) : Int
    fun gpio_wave_delete = gpioWaveDelete(wave_id : UInt) : Int
    fun gpio_wave_tx_send = gpioWaveTxSend(wave_id : UInt, wave_mode : UInt) : Int
    fun gpio_wave_chain = gpioWaveChain(buf : LibC::Char*, bufSize : UInt) : Int
    fun gpio_wave_tx_at = gpioWaveTxAt : Int
    fun gpio_wave_tx_busy = gpioWaveTxBusy : Int
    fun gpio_wave_tx_stop = gpioWaveTxStop : Int
    fun gpio_wave_get_micros = gpioWaveGetMicros : Int
    fun gpio_wave_get_high_micros = gpioWaveGetHighMicros : Int
    fun gpio_wave_get_max_micros = gpioWaveGetMaxMicros : Int
    fun gpio_wave_get_pulses = gpioWaveGetPulses : Int
    fun gpio_wave_get_high_pulses = gpioWaveGetHighPulses : Int
    fun gpio_wave_get_max_pulses = gpioWaveGetMaxPulses : Int
    fun gpio_wave_get_cbs = gpioWaveGetCbs : Int
    fun gpio_wave_get_high_cbs = gpioWaveGetHighCbs : Int
    fun gpio_wave_get_max_cbs = gpioWaveGetMaxCbs : Int
    fun gpio_serial_read_open = gpioSerialReadOpen(user_gpio : UInt, baud : UInt, data_bits : UInt) : Int
    fun gpio_serial_read_invert = gpioSerialReadInvert(user_gpio : UInt, invert : UInt) : Int
    fun gpio_serial_read = gpioSerialRead(user_gpio : UInt, buf : Void*, bufSize : LibC::SizeT) : Int
    fun gpio_serial_read_close = gpioSerialReadClose(user_gpio : UInt) : Int
    fun i2c_open = i2cOpen(i2c_bus : UInt, i2c_addr : UInt, i2c_flags : UInt) : Int
    fun i2c_close = i2cClose(handle : UInt) : Int
    fun i2c_write_quick = i2cWriteQuick(handle : UInt, bit : UInt) : Int
    fun i2c_write_byte = i2cWriteByte(handle : UInt, b_val : UInt) : Int
    fun i2c_read_byte = i2cReadByte(handle : UInt) : Int
    fun i2c_write_byte_data = i2cWriteByteData(handle : UInt, i2c_reg : UInt, b_val : UInt) : Int
    fun i2c_write_word_data = i2cWriteWordData(handle : UInt, i2c_reg : UInt, w_val : UInt) : Int
    fun i2c_read_byte_data = i2cReadByteData(handle : UInt, i2c_reg : UInt) : Int
    fun i2c_read_word_data = i2cReadWordData(handle : UInt, i2c_reg : UInt) : Int
    fun i2c_process_call = i2cProcessCall(handle : UInt, i2c_reg : UInt, w_val : UInt) : Int
    fun i2c_write_block_data = i2cWriteBlockData(handle : UInt, i2c_reg : UInt, buf : LibC::Char*, count : UInt) : Int
    fun i2c_read_block_data = i2cReadBlockData(handle : UInt, i2c_reg : UInt, buf : LibC::Char*) : Int
    fun i2c_block_process_call = i2cBlockProcessCall(handle : UInt, i2c_reg : UInt, buf : LibC::Char*, count : UInt) : Int
    fun i2c_read_i2c_block_data = i2cReadI2CBlockData(handle : UInt, i2c_reg : UInt, buf : LibC::Char*, count : UInt) : Int
    fun i2c_write_i2c_block_data = i2cWriteI2CBlockData(handle : UInt, i2c_reg : UInt, buf : LibC::Char*, count : UInt) : Int
    fun i2c_read_device = i2cReadDevice(handle : UInt, buf : LibC::Char*, count : UInt) : Int
    fun i2c_write_device = i2cWriteDevice(handle : UInt, buf : LibC::Char*, count : UInt) : Int
    fun i2c_switch_combined = i2cSwitchCombined(setting : Int) : Void
    fun i2c_segments = i2cSegments(handle : UInt, segs : PiIc2MsgT*, num_segs : UInt) : Int
    fun i2c_zip = i2cZip(handle : UInt, in_buf : LibC::Char*, in_len : UInt, out_buf : LibC::Char*, out_len : UInt) : Int
    fun bb_i2c_open = bbI2COpen(sda : UInt, scl : UInt, baud : UInt) : Int
    fun bb_i2c_close = bbI2CClose(sda : UInt) : Int
    fun bb_i2c_zip = bbI2CZip(sda : UInt, in_buf : LibC::Char*, in_len : UInt, out_buf : LibC::Char*, out_len : UInt) : Int
    fun bsc_transfer = bscXfer(bsc_xfer : BscXferT*) : Int
    fun bb_spi_open = bbSPIOpen(cs : UInt, miso : UInt, mosi : UInt, sclk : UInt, baud : UInt, spi_flags : UInt) : Int
    fun bb_spi_close = bbSPIClose(cs : UInt) : Int
    fun bb_spi_transfer = bbSPIXfer(cs : UInt, in_buf : LibC::Char*, out_buf : LibC::Char*, count : UInt) : Int
    fun spi_open = spiOpen(spi_chan : UInt, baud : UInt, spi_flags : UInt) : Int
    fun spi_close = spiClose(handle : UInt) : Int
    fun spi_read = spiRead(handle : UInt, buf : LibC::Char*, count : UInt) : Int
    fun spi_write = spiWrite(handle : UInt, buf : LibC::Char*, count : UInt) : Int
    fun spi_transfer = spiXfer(handle : UInt, tx_buf : LibC::Char*, rx_buf : LibC::Char*, count : UInt) : Int
    fun ser_open = serOpen(ser_tty : LibC::Char*, baud : UInt, ser_flags : UInt) : Int
    fun ser_close = serClose(handle : UInt) : Int
    fun ser_write_byte = serWriteByte(handle : UInt, b_val : UInt) : Int
    fun ser_read_byte = serReadByte(handle : UInt) : Int
    fun ser_write = serWrite(handle : UInt, buf : LibC::Char*, count : UInt) : Int
    fun ser_read = serRead(handle : UInt, buf : LibC::Char*, count : UInt) : Int
    fun ser_data_available = serDataAvailable(handle : UInt) : Int
    fun gpio_trigger = gpioTrigger(user_gpio : UInt, pulse_len : UInt, level : UInt) : Int
    fun gpio_set_watchdog = gpioSetWatchdog(user_gpio : UInt, timeout : UInt) : Int
    fun gpio_noise_filter = gpioNoiseFilter(user_gpio : UInt, steady : UInt, active : UInt) : Int
    fun gpio_glitch_filter = gpioGlitchFilter(user_gpio : UInt, steady : UInt) : Int
    fun gpio_set_get_samples_func = gpioSetGetSamplesFunc(f : GpioGetSamplesFuncT, bits : UInt32T) : Int
    fun gpio_set_get_samples_func_ex = gpioSetGetSamplesFuncEx(f : GpioGetSamplesFuncExT, bits : UInt32T, userdata : Void*) : Int
    fun gpio_set_timer_func = gpioSetTimerFunc(timer : UInt, millis : UInt, f : GpioTimerFuncT) : Int
    fun gpio_set_timer_func_ex = gpioSetTimerFuncEx(timer : UInt, millis : UInt, f : GpioTimerFuncExT, userdata : Void*) : Int
    fun gpio_start_thread = gpioStartThread(f : GpioThreadFuncT, userdata : Void*) : LibC::PthreadT
    fun gpio_stop_thread = gpioStopThread(pth : LibC::PthreadT*) : Void
    fun gpio_store_script = gpioStoreScript(script : LibC::Char*) : Int
    fun gpio_run_script = gpioRunScript(script_id : UInt, num_par : UInt, param : UInt32T*) : Int
    fun gpio_update_script = gpioUpdateScript(script_id : UInt, num_par : UInt, param : UInt32T*) : Int
    fun gpio_script_status = gpioScriptStatus(script_id : UInt, param : UInt32T*) : Int
    fun gpio_stop_script = gpioStopScript(script_id : UInt) : Int
    fun gpio_delete_script = gpioDeleteScript(script_id : UInt) : Int
    fun gpio_set_signal_func = gpioSetSignalFunc(signum : UInt, f : GpioSignalFuncT) : Int
    fun gpio_set_signal_func_ex = gpioSetSignalFuncEx(signum : UInt, f : GpioSignalFuncExT, userdata : Void*) : Int
    fun gpio_read_bits_0_31 = gpioRead_Bits_0_31 : UInt32T
    fun gpio_read_bits_32_53 = gpioRead_Bits_32_53 : UInt32T
    fun gpio_write_bits_0_31_clear = gpioWrite_Bits_0_31_Clear(bits : UInt32T) : Int
    fun gpio_write_bits_32_53_clear = gpioWrite_Bits_32_53_Clear(bits : UInt32T) : Int
    fun gpio_write_bits_0_31_set = gpioWrite_Bits_0_31_Set(bits : UInt32T) : Int
    fun gpio_write_bits_32_53_set = gpioWrite_Bits_32_53_Set(bits : UInt32T) : Int
    fun gpio_hardware_clock = gpioHardwareClock(gpio : UInt, clk_freq : UInt) : Int
    fun gpio_hardware_pwm = gpioHardwarePWM(gpio : UInt, pwm_freq : UInt, pwm_duty : UInt) : Int
    fun gpio_time = gpioTime(timetype : UInt, seconds : Int*, micros : Int*) : Int
    fun gpio_sleep = gpioSleep(timetype : UInt, seconds : Int, micros : Int) : Int
    fun gpio_delay = gpioDelay(micros : UInt32T) : UInt32T
    fun gpio_tick = gpioTick : UInt32T
    fun gpio_hardware_revision = gpioHardwareRevision : UInt
    fun gpio_version = gpioVersion : UInt
    fun gpio_get_pad = gpioGetPad(pad : UInt) : Int
    fun gpio_set_pad = gpioSetPad(pad : UInt, pad_strength : UInt) : Int
    fun event_monitor = eventMonitor(handle : UInt, bits : UInt32T) : Int
    fun event_set_func = eventSetFunc(event : UInt, f : EventFuncT) : Int
    fun event_set_func_ex = eventSetFuncEx(event : UInt, f : EventFuncExT, userdata : Void*) : Int
    fun event_trigger = eventTrigger(event : UInt) : Int
    fun shell(script_name : LibC::Char*, script_string : LibC::Char*) : Int
    fun file_open = fileOpen(file : LibC::Char*, mode : UInt) : Int
    fun file_close = fileClose(handle : UInt) : Int
    fun file_write = fileWrite(handle : UInt, buf : LibC::Char*, count : UInt) : Int
    fun file_read = fileRead(handle : UInt, buf : LibC::Char*, count : UInt) : Int
    fun file_seek = fileSeek(handle : UInt, seek_offset : Int32T, seek_from : Int) : Int
    fun file_list = fileList(fpat : LibC::Char*, buf : LibC::Char*, count : UInt) : Int
    fun gpio_cfg_buffer_size = gpioCfgBufferSize(cfg_millis : UInt) : Int
    fun gpio_cfg_clock = gpioCfgClock(cfg_micros : UInt, cfg_peripheral : UInt, cfg_source : UInt) : Int
    fun gpio_cfg_dma_channels = gpioCfgDMAchannels(primary_channel : UInt, secondary_channel : UInt) : Int
    fun gpio_cfg_permissions = gpioCfgPermissions(update_mask : UInt64T) : Int
    fun gpio_cfg_socket_port = gpioCfgSocketPort(port : UInt) : Int
    fun gpio_cfg_interfaces = gpioCfgInterfaces(if_flags : UInt) : Int
    fun gpio_cfg_mem_alloc = gpioCfgMemAlloc(mem_alloc_mode : UInt) : Int
    fun gpio_cfg_net_addr = gpioCfgNetAddr(num_sock_addr : Int, sock_addr : UInt32T*) : Int
    fun gpio_cfg_get_internals = gpioCfgGetInternals : UInt32T
    fun gpio_cfg_set_internals = gpioCfgSetInternals(cfg_val : UInt32T) : Int
    fun raw_wave_add_spi = rawWaveAddSPI(spi : RawSpiT*, offset : UInt, spi_ss : UInt, buf : LibC::Char*, spi_tx_bits : UInt, spi_bit_first : UInt, spi_bit_last : UInt, spi_bits : UInt) : Int
    fun raw_wave_add_generic = rawWaveAddGeneric(num_pulses : UInt, pulses : RawWaveT*) : Int
    fun raw_wave_cb = rawWaveCB : UInt
    fun raw_wave_cb_adr = rawWaveCBAdr(cb_num : Int) : RawCbsT*
    fun raw_wave_get_ool = rawWaveGetOOL(pos : Int) : UInt32T
    fun raw_wave_set_ool = rawWaveSetOOL(pos : Int, l_val : UInt32T) : Void
    fun raw_wave_get_out = rawWaveGetOut(pos : Int) : UInt32T
    fun raw_wave_set_out = rawWaveSetOut(pos : Int, l_val : UInt32T) : Void
    fun raw_wave_get_in = rawWaveGetIn(pos : Int) : UInt32T
    fun raw_wave_set_in = rawWaveSetIn(pos : Int, l_val : UInt32T) : Void
    fun raw_wave_info = rawWaveInfo(wave_id : Int) : RawWaveInfoT
    fun get_bit_in_bytes = getBitInBytes(bit_pos : Int, buf : LibC::Char*, num_bits : Int) : Int
    fun put_bit_in_bytes = putBitInBytes(bit_pos : Int, buf : LibC::Char*, bit : Int) : Void
    fun time_time : LibC::Double
    fun time_sleep(seconds : LibC::Double) : Void
    fun raw_dump_wave = rawDumpWave : Void
    fun raw_dump_script = rawDumpScript(script_id : UInt) : Void

    # Variables
    $gpioCustom1 : GpioCustom1
    $gpioCustom2 : GpioCustom2
  end
end
