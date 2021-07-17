module Pigpio
  @[Link("pigpio")]
  lib LibPigpio
    alias Int = LibC::Int
    alias UInt = LibC::UInt
    alias UInt8T = LibC::UInt8T
    alias UInt16T = LibC::UInt16T
    alias UInt32T = LibC::UInt32T

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
    RISING_EDGE                =      0
    FALLING_EDGE               =      1
    EITHER_EDGE                =      2
    PI_FILE_READ               =      1
    PI_FILE_WRITE              =      2
    PI_FILE_RW                 =      3
    PI_FILE_APPEND             =      4
    PI_FILE_CREATE             =      8
    PI_FILE_TRUNC              =     16
    PI_FROM_START              =      0
    PI_FROM_CURRENT            =      1
    PI_FROM_END                =      2
    PI_EVENT_BSC               =     31

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

    struct GpioPulse
      gpioOn, gpioOff, usDelay : UInt32T
    end

    type GpioPulseT = GpioPulse

    struct RawWave
      gpioOn, gpioOff, usDelay, flags : UInt32T
    end

    type RawWaveT = RawWave

    struct RawWaveInfo
      botCB, topCB, botOOL, topOOL, deleted, numCB, numBOOL, numTOOL : UInt16T
    end

    type RawWaveInfoT = RawWaveInfo

    struct RawSPI
      clk, mosi, miso, ss_pol, ss_us, clk_pol, clk_pha, clk_us : Int
    end

    type RawSPIT = RawSPI

    struct RawCbs
      info, src, dst, length, stride, next : UInt32T
      pad : UInt32T[2]
    end

    type RawCbsT = RawCbs

    struct PiIc2Msg
      addr, flags, len : UInt16T
      buf : UInt8T*
    end

    type PiIc2MsgT = PiIc2Msg

    struct BscXfer
      control : UInt32T
      rxCnt, txCnt : Int
      rxBuf, txBuf : LibC::Char[BSC_FIFO_SIZE]
    end

    type BscXferT = BscXfer

    type GpioAlertFuncT = Int, Int, UInt32T -> Void
    type GpioAlertFuncExT = Int, Int, UInt32T, Void* -> Void
    type EventFuncT = Int, UInt32T -> Void
    type EventFuncExT = Int, UInt32T, Void* -> Void
    type GpioISRFuncT = Int, Int, UInt32T -> Void
    type GpioISRFuncExT = Int, Int, UInt32T, Void* -> Void
    type GpioTimerFuncT = -> Void
    type GpioTimerFuncExT = Void* -> Void
    type GpioSignalFuncT = Int -> Void
    type GpioSignalFuncExT = Int, Void* -> Void
    type GpioGetSamplesFuncT = GpioSampleT*, Int -> Void
    type GpioGetSamplesFuncExT = GpioSampleT*, Int, Void* -> Void
    type GpioThreadFuncT = Void* -> Void*

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
    fun gpio_wave_delete = gpioWaveCreate(wave_id : UInt) : Int
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
    # stopped at 2297
  end
end
