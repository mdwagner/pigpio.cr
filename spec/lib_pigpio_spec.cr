require "./spec_helper"

class Globals
  class_property t2_count = 0

  class_property t3_reset = 1
  class_property t3_count = 0
  class_property t3_tick : UInt32 = 0
  class_property t3_on = 0.0
  class_property t3_off = 0.0

  class_property t5_count = 0

  class_property t6_count = 0
  class_property t6_on = 0
  class_property t6_on_tick : UInt32 = 0

  class_property t7_count = 0

  class_property t9_count = 0

  def self.reset : Void
    t2_count = 0

    t3_reset = 1
    t3_count = 0
    t3_tick = 0
    t3_on = 0.0
    t3_off = 0.0

    t5_count = 0

    t6_count = 0
    t6_on = 0
    t6_on_tick = 0

    t7_count = 0

    t9_count = 0
  end
end

Spectator.describe "LibPigpio" do
  alias LibPigpio = Pigpio::LibPigpio

  GPIO     =         25
  USERDATA = 18_249_013
  BAUD     =      4_800

  before_all { LibPigpio.gpio_init < 0 && raise "pigpio init failed" }
  after_all { LibPigpio.gpio_terminate }
  before_each { Globals.reset }

  it "Testing pigpio C I/F" do
    expect(LibPigpio.gpio_version).to be_gt(0)

    unless LibPigpio.gpio_hardware_revision > 0
      puts "Hardware revision cannot be found or is not a valid hexadecimal number"
    end
  end

  it "Mode/PUD/read/write tests" do
    LibPigpio.gpio_set_mode(GPIO, LibPigpio::PI_INPUT)
    v = LibPigpio.gpio_get_mode(GPIO)
    expect(v).to be_checked_against(0)

    LibPigpio.gpio_set_pull_up_down(GPIO, LibPigpio::PI_PUD_UP)
    LibPigpio.gpio_delay(1) # 1 micro delay to let GPIO reach level reliably
    v = LibPigpio.gpio_read(GPIO)
    expect(v).to be_checked_against(1)

    LibPigpio.gpio_set_pull_up_down(GPIO, LibPigpio::PI_PUD_DOWN)
    LibPigpio.gpio_delay(1) # 1 micro delay to let GPIO reach level reliably
    v = LibPigpio.gpio_read(GPIO)
    expect(v).to be_checked_against(0)

    LibPigpio.gpio_write(GPIO, LibPigpio::PI_LOW)
    v = LibPigpio.gpio_get_mode(GPIO)
    expect(v).to be_checked_against(1)

    v = LibPigpio.gpio_read(GPIO)
    expect(v).to be_checked_against(0)

    LibPigpio.gpio_write(GPIO, LibPigpio::PI_HIGH)
    LibPigpio.gpio_delay(1) # 1 micro delay to let GPIO reach level reliably
    v = LibPigpio.gpio_read(GPIO)
    expect(v).to be_checked_against(1)
  end

  it "PWM dutycycle/range/frequency tests" do
    LibPigpio.gpio_set_pwm_range(GPIO, 255)
    LibPigpio.gpio_set_pwm_freq(GPIO, 0)
    f = LibPigpio.gpio_get_pwm_freq(GPIO)
    expect(f).to be_checked_against(10)

    t2cb = LibPigpio::GpioAlertFuncT.new { Globals.t2_count += 1 }
    LibPigpio.gpio_set_alert_func(GPIO, t2cb)

    LibPigpio.gpio_pwm(GPIO, 0)
    dc = LibPigpio.gpio_get_pwm_dutycycle(GPIO)
    expect(dc).to be_checked_against(0)

    LibPigpio.time_sleep(0.5) # allow old notifications to flush
    oc = Globals.t2_count
    LibPigpio.time_sleep(2)
    f = Globals.t2_count - oc
    expect(f).to be_checked_against(0)

    LibPigpio.gpio_pwm(GPIO, 128)
    dc = LibPigpio.gpio_get_pwm_dutycycle(GPIO)
    expect(dc).to be_checked_against(128)

    oc = Globals.t2_count
    LibPigpio.time_sleep(2)
    f = Globals.t2_count - oc
    expect(f).to be_checked_against(40, 5)

    LibPigpio.gpio_set_pwm_freq(GPIO, 100)
    f = LibPigpio.gpio_get_pwm_freq(GPIO)
    expect(f).to be_checked_against(100)

    oc = Globals.t2_count
    LibPigpio.time_sleep(2)
    f = Globals.t2_count - oc
    expect(f).to be_checked_against(400, 1)

    LibPigpio.gpio_set_pwm_freq(GPIO, 1000)
    f = LibPigpio.gpio_get_pwm_freq(GPIO)
    expect(f).to be_checked_against(1000)

    oc = Globals.t2_count
    LibPigpio.time_sleep(2)
    f = Globals.t2_count - oc
    expect(f).to be_checked_against(4000, 1)

    r = LibPigpio.gpio_get_pwm_range(GPIO)
    expect(r).to be_checked_against(255)

    rr = LibPigpio.gpio_get_pwm_real_range(GPIO)
    expect(rr).to be_checked_against(200)

    LibPigpio.gpio_set_pwm_range(GPIO, 2000)
    r = LibPigpio.gpio_get_pwm_range(GPIO)
    expect(r).to be_checked_against(2000)

    rr = LibPigpio.gpio_get_pwm_real_range(GPIO)
    expect(rr).to be_checked_against(200)

    LibPigpio.gpio_pwm(GPIO, 0)
  end

  it "PWM/Servo pulse accuracy tests" do
    pw = StaticArray[500, 1_500, 2_500]
    dc = StaticArray[20, 40, 60, 80]

    t3cbf = LibPigpio::GpioAlertFuncT.new do |gpio, level, tick|
      if Globals.t3_reset == 1
        Globals.t3_count = 0
        Globals.t3_on = 0.0
        Globals.t3_off = 0.0
        Globals.t3_reset = 0
      else
        td = tick - Globals.t3_tick

        if level == 0
          Globals.t3_on += td
        else
          Globals.t3_off += td
        end
      end

      Globals.t3_count += 1
      Globals.t3_tick = tick
    end
    t3cbf_box = Box(typeof(t3cbf)).box(t3cbf)
    t3cbf_f = LibPigpio::GpioAlertFuncExT.new do |gpio, level, tick, userdata|
      Box(typeof(t3cbf)).unbox(userdata).call(gpio, level, tick)
    end
    LibPigpio.gpio_set_alert_func_ex(GPIO, t3cbf_f, t3cbf_box) # test extended alert

    3.times do |t|
      LibPigpio.gpio_servo(GPIO, pw[t])
      v = LibPigpio.gpio_get_servo_pulsewidth(GPIO)
      expect(v).to be_checked_against(pw[t])

      LibPigpio.time_sleep(1)
      Globals.t3_reset = 1
      LibPigpio.time_sleep(4)
      on = Globals.t3_on
      off = Globals.t3_off
      expect((1e3*(on + off))/on).to be_checked_against(2e7/pw[t], 1)
    end

    LibPigpio.gpio_servo(GPIO, 0)
    LibPigpio.gpio_set_pwm_freq(GPIO, 1_000)
    f = LibPigpio.gpio_get_pwm_freq(GPIO)
    expect(f).to be_checked_against(1_000)

    rr = LibPigpio.gpio_set_pwm_range(GPIO, 100)
    expect(rr).to be_checked_against(200)

    4.times do |t|
      LibPigpio.gpio_pwm(GPIO, dc[t])
      v = LibPigpio.gpio_get_pwm_dutycycle(GPIO)
      expect(v).to be_checked_against(dc[t])

      LibPigpio.time_sleep(1)
      Globals.t3_reset = 1
      LibPigpio.time_sleep(2)
      on = Globals.t3_on
      off = Globals.t3_off
      expect((1e3*on)/(on + off)).to be_checked_against(1e1*dc[t], 1)
    end

    LibPigpio.gpio_pwm(GPIO, 0)
  end

  it "Pipe notification tests" do
    LibPigpio.gpio_set_pwm_freq(GPIO, 0)
    LibPigpio.gpio_pwm(GPIO, 0)
    LibPigpio.gpio_set_pwm_range(GPIO, 100)

    h = LibPigpio.gpio_notify_open

    n = 0
    s = 0
    l = 0
    seq_ok = 1
    toggle_ok = 1

    File.open("/dev/pigpio#{h}", "r") do |f|
      e = LibPigpio.gpio_notify_begin(h, (1 << GPIO))
      expect(e).to be_checked_against(0)

      LibPigpio.gpio_pwm(GPIO, 50)
      LibPigpio.time_sleep(4)
      LibPigpio.gpio_pwm(GPIO, 0)

      e = LibPigpio.gpio_notify_pause(h)
      expect(e).to be_checked_against(0)

      e = LibPigpio.gpio_notify_close(h)
      expect(e).to be_checked_against(0)

      loop do
        bytes = Bytes.new(12)
        if f.read(bytes) == 12
          r = bytes.to_unsafe.as(LibPigpio::GpioReportT*).value

          seq_ok = 0 if s != r.seqno

          if n != 0 && l != (r.level & (1 << GPIO))
            toggle_ok = 0
          end

          if (r.level & (1 << GPIO)) != 0
            l = 0
          else
            l = (1 << GPIO)
          end

          s += 1
          n += 1
        else
          break
        end
      end
    end

    expect(seq_ok).to be_checked_against(1)
    expect(toggle_ok).to be_checked_against(1)
    expect(n).to be_checked_against(80, 10)
  end

  def t5_TEXT
    <<-TEXT
    \nNow is the winter of our discontent
    Made glorious summer by this sun of York;
    And all the clouds that lour'd upon our house
    In the deep bosom of the ocean buried.
    Now are our brows bound with victorious wreaths;
    Our bruised arms hung up for monuments;
    Our stern alarums changed to merry meetings,
    Our dreadful marches to delightful measures.
    Grim-visaged war hath smooth'd his wrinkled front;
    And now, instead of mounting barded steeds
    To fright the souls of fearful adversaries,
    He capers nimbly in a lady's chamber
    To the lascivious pleasing of a lute.\n
    TEXT
  end

  it "Waveforms & serial read/writes tests" do
    wf = StaticArray[
      LibPigpio::GpioPulseT.new(gpioOn: (1 << GPIO), gpioOff: 0, usDelay: 10_000),
      LibPigpio::GpioPulseT.new(gpioOn: 0, gpioOff: (1 << GPIO), usDelay: 30_000),
      LibPigpio::GpioPulseT.new(gpioOn: (1 << GPIO), gpioOff: 0, usDelay: 60_000),
      LibPigpio::GpioPulseT.new(gpioOn: 0, gpioOff: (1 << GPIO), usDelay: 100_000),
    ]
    text = uninitialized LibC::Char[2048]

    t5cbf = LibPigpio::GpioAlertFuncT.new do |gpio, level, tick|
      Globals.t5_count += 1 if level == 0 # falling edges
    end
    LibPigpio.gpio_set_alert_func(GPIO, t5cbf)

    LibPigpio.gpio_set_mode(GPIO, LibPigpio::PI_OUTPUT)

    e = LibPigpio.gpio_wave_clear
    expect(e).to be_checked_against(0)

    e = LibPigpio.gpio_wave_add_generic(4, wf)
    expect(e).to be_checked_against(4)

    wid = LibPigpio.gpio_wave_create
    e = LibPigpio.gpio_wave_tx_send(wid, LibPigpio::PI_WAVE_MODE_REPEAT)

    if e < 14
      expect(e).to be_checked_against(9)
    else
      expect(e).to be_checked_against(19)
    end

    oc = Globals.t5_count
    LibPigpio.time_sleep(5)
    c = Globals.t5_count - oc
    expect(c).to be_checked_against(50, 1)

    e = LibPigpio.gpio_wave_tx_stop
    expect(e).to be_checked_against(0)

    # gpio_serial_read_open changes the alert function

    e = LibPigpio.gpio_serial_read_open(GPIO, BAUD, 8)
    expect(e).to be_checked_against(0)

    LibPigpio.gpio_wave_clear
    e = LibPigpio.gpio_wave_add_serial(GPIO, BAUD, 8, 2, 5_000_000, t5_TEXT.bytesize, t5_TEXT)
    expect(e).to be_checked_against(3_405)

    wid = LibPigpio.gpio_wave_create
    e = LibPigpio.gpio_wave_tx_send(wid, LibPigpio::PI_WAVE_MODE_ONE_SHOT)

    if e < 6_964
      expect(e).to be_checked_against(6_811)
    else
      expect(e).to be_checked_against(7_116)
    end

    while LibPigpio.gpio_wave_tx_busy != 0
      LibPigpio.time_sleep(0.1)
    end
    LibPigpio.time_sleep(0.1)
    c = LibPigpio.gpio_serial_read(GPIO, pointerof(text), sizeof(typeof(text)) - 1)

    text[c] = 0 if c > 0
    expect(String.new(text.to_slice)).to contain(t5_TEXT)

    e = LibPigpio.gpio_serial_read_close(GPIO)
    expect(e).to be_checked_against(0)

    c = LibPigpio.gpio_wave_get_micros
    expect(c).to be_checked_against(6_158_148)

    c = LibPigpio.gpio_wave_get_high_micros
    expect(c).to be_checked_against(6_158_148)

    c = LibPigpio.gpio_wave_get_max_micros
    expect(c).to be_checked_against(1_800_000_000)

    c = LibPigpio.gpio_wave_get_pulses
    expect(c).to be_checked_against(3_405)

    c = LibPigpio.gpio_wave_get_high_pulses
    expect(c).to be_checked_against(3_405)

    c = LibPigpio.gpio_wave_get_max_pulses
    expect(c).to be_checked_against(12_000)

    c = LibPigpio.gpio_wave_get_cbs

    if e < 6_963
      expect(c).to be_checked_against(6_810)
    else
      expect(c).to be_checked_against(7_115)
    end

    c = LibPigpio.gpio_wave_get_high_cbs

    if e < 6_963
      expect(c).to be_checked_against(6_810)
    else
      expect(c).to be_checked_against(7_115)
    end

    c = LibPigpio.gpio_wave_get_max_cbs
    expect(c).to be_checked_against(25_016)

    # wave_create_pad tests
    LibPigpio.gpio_wave_tx_stop
    LibPigpio.gpio_wave_clear
    LibPigpio.gpio_set_alert_func(GPIO, t5cbf)

    pulses = StaticArray[
      LibPigpio::GpioPulseT.new(gpioOn: (1 << GPIO), gpioOff: 0, usDelay: 10_000),
      LibPigpio::GpioPulseT.new(gpioOn: 0, gpioOff: (1 << GPIO), usDelay: 30_000),
    ]
    e = LibPigpio.gpio_wave_add_generic(2, pulses)
    wid = LibPigpio.gpio_wave_create_pad(50, 50, 0)
    expect(wid).to be_checked_against(0)

    pulses = StaticArray[
      LibPigpio::GpioPulseT.new(gpioOn: (1 << GPIO), gpioOff: 0, usDelay: 10_000),
      LibPigpio::GpioPulseT.new(gpioOn: 0, gpioOff: (1 << GPIO), usDelay: 30_000),
      LibPigpio::GpioPulseT.new(gpioOn: (1 << GPIO), gpioOff: 0, usDelay: 60_000),
      LibPigpio::GpioPulseT.new(gpioOn: 0, gpioOff: (1 << GPIO), usDelay: 100_000),
    ]
    e = LibPigpio.gpio_wave_add_generic(4, pulses)
    wid = LibPigpio.gpio_wave_create_pad(50, 50, 0)
    expect(wid).to be_checked_against(1)

    c = LibPigpio.gpio_wave_delete(0)
    expect(c).to be_checked_against(0)

    pulses = StaticArray[
      LibPigpio::GpioPulseT.new(gpioOn: (1 << GPIO), gpioOff: 0, usDelay: 10_000),
      LibPigpio::GpioPulseT.new(gpioOn: 0, gpioOff: (1 << GPIO), usDelay: 30_000),
      LibPigpio::GpioPulseT.new(gpioOn: (1 << GPIO), gpioOff: 0, usDelay: 60_000),
      LibPigpio::GpioPulseT.new(gpioOn: 0, gpioOff: (1 << GPIO), usDelay: 100_000),
      LibPigpio::GpioPulseT.new(gpioOn: (1 << GPIO), gpioOff: 0, usDelay: 60_000),
      LibPigpio::GpioPulseT.new(gpioOn: 0, gpioOff: (1 << GPIO), usDelay: 100_000),
    ]
    e = LibPigpio.gpio_wave_add_generic(6, pulses)
    c = LibPigpio.gpio_wave_create
    expect(c).to be_checked_against(-67)
    wid = LibPigpio.gpio_wave_create_pad(50, 50, 0)
    expect(wid).to be_checked_against(0)

    Globals.t5_count = 0
    e = LibPigpio.gpio_wave_chain(LibC::Char[1, 0], 2)
    expect(e).to be_checked_against(0)
    while LibPigpio.gpio_wave_tx_busy != 0
      LibPigpio.time_sleep(0.1)
    end
    expect(Globals.t5_count).to be_checked_against(5, 1)

    noop = LibPigpio::GpioAlertFuncT.new { }
    LibPigpio.gpio_set_alert_func(GPIO, noop)
  end

  it "Trigger tests" do
    LibPigpio.gpio_write(GPIO, LibPigpio::PI_LOW)

    tp = 0

    t6cbf = LibPigpio::GpioAlertFuncT.new do |gpio, level, tick|
      if level == 1
        Globals.t6_on_tick = tick
        Globals.t6_count += 1
      else
        Globals.t6_on += (tick - Globals.t6_on_tick) if Globals.t6_on_tick != 0
      end
    end
    LibPigpio.gpio_set_alert_func(GPIO, t6cbf)

    5.times do |t|
      LibPigpio.time_sleep(0.1)
      x = 10 + (t * 10)
      tp += x
      LibPigpio.gpio_trigger(GPIO, x, 1)
    end

    LibPigpio.time_sleep(0.2)

    expect(Globals.t6_count).to be_checked_against(5)
    expect(Globals.t6_on).to be_checked_against(tp, 25)
  end

  it "Watchdog tests" do
    t7cbf = LibPigpio::GpioAlertFuncT.new do |gpio, level, tick|
      Globals.t7_count += 1 if level == LibPigpio::PI_TIMEOUT
    end
    # type of edge shouldn't matter for watchdogs
    LibPigpio.gpio_set_alert_func(GPIO, t7cbf)

    LibPigpio.gpio_set_watchdog(GPIO, 50) # 50 ms, 20 per second
    LibPigpio.time_sleep(0.5)
    oc = Globals.t7_count
    LibPigpio.time_sleep(2)
    c = Globals.t7_count - oc
    expect(c).to be_checked_against(39, 5)

    LibPigpio.gpio_set_watchdog(GPIO, 0) # 0 switches watchdog off
    LibPigpio.time_sleep(0.5)
    oc = Globals.t7_count
    LibPigpio.time_sleep(2)
    c = Globals.t7_count - oc
    expect(c).to be_checked_against(0, 1)
  end

  it "Bank read/write tests" do
    LibPigpio.gpio_write(GPIO, 0)
    v = LibPigpio.gpio_read_bits_0_31 & (1 << GPIO)
    expect(v).to be_checked_against(0)

    LibPigpio.gpio_write(GPIO, 1)
    v = LibPigpio.gpio_read_bits_0_31 & (1 << GPIO)
    expect(v).to be_checked_against((1 << GPIO))

    LibPigpio.gpio_write_bits_0_31_clear((1 << GPIO))
    v = LibPigpio.gpio_read(GPIO)
    expect(v).to be_checked_against(0)

    LibPigpio.gpio_write_bits_0_31_set((1 << GPIO))
    v = LibPigpio.gpio_read(GPIO)
    expect(v).to be_checked_against(1)

    v = LibPigpio.gpio_read_bits_32_53

    if v != 0
      v = 0
    else
      v = 1
    end

    expect(v).to be_checked_against(0)

    v = LibPigpio.gpio_write_bits_32_53_clear(0)
    expect(v).to be_checked_against(0)

    v = LibPigpio.gpio_write_bits_32_53_set(0)
    expect(v).to be_checked_against(0)
  end

  it "Script store/run/status/stop/delete tests" do
    script_param = uninitialized UInt32[10]

    script = %[ld p9 p0 tag 0 w p1 1 mils 5 w p1 0 mils 5 dcr p9 jp 0]

    LibPigpio.gpio_write(GPIO, 0) # need known state

    Globals.t9_count = 0

    t9cbf = LibPigpio::GpioAlertFuncT.new do |gpio, level, tick|
      Globals.t9_count += 1 if level == 1
    end
    LibPigpio.gpio_set_alert_func(GPIO, t9cbf)

    s = LibPigpio.gpio_store_script(script)

    loop do
      # loop until script initialized
      LibPigpio.time_sleep(0.1)
      e = LibPigpio.gpio_script_status(s, script_param)
      break if e != LibPigpio::PI_SCRIPT_INITING
    end

    oc = Globals.t9_count
    script_param[0] = 99
    script_param[1] = GPIO.to_u32
    LibPigpio.gpio_run_script(s, 2, script_param)
    LibPigpio.time_sleep(2)
    c = Globals.t9_count - oc
    expect(c).to be_checked_against(100)

    oc = Globals.t9_count
    script_param[0] = 200
    script_param[1] = GPIO.to_u32
    LibPigpio.gpio_run_script(s, 2, script_param)
    LibPigpio.time_sleep(0.1)
    loop do
      e = LibPigpio.gpio_script_status(s, script_param)
      break if e != LibPigpio::PI_SCRIPT_RUNNING
      LibPigpio.time_sleep(0.5)
    end
    c = Globals.t9_count - oc
    LibPigpio.time_sleep(0.1)
    expect(c).to be_checked_against(201)

    oc = Globals.t9_count
    script_param[0] = 2_000
    script_param[1] = GPIO.to_u32
    LibPigpio.gpio_run_script(s, 2, script_param)
    LibPigpio.time_sleep(0.1)
    loop do
      e = LibPigpio.gpio_script_status(s, script_param)
      break if e != LibPigpio::PI_SCRIPT_RUNNING
      LibPigpio.gpio_stop_script(s) if script_param[9] < 1_900
      LibPigpio.time_sleep(0.1)
    end
    c = Globals.t9_count - oc
    LibPigpio.time_sleep(0.1)
    expect(c).to be_checked_against(110, 10)

    e = LibPigpio.gpio_delete_script(s)
    expect(e).to be_checked_against(0)
  end

  def ta_TEXT
    "To be, or not to be, that is the question-\
    Whether 'tis Nobler in the mind to suffer\
    The Slings and Arrows of outrageous Fortune,\
    Or to take Arms against a Sea of troubles,"
  end

  it "Serial link tests" do
    text = uninitialized LibC::Char[2048]

    # this test needs RXD and TXD to be connected

    h = LibPigpio.ser_open("/dev/ttyAMA0", 57_600, 0)

    expect(h).to be_checked_against(0)

    b = LibPigpio.ser_read(h, text, sizeof(typeof(text))) # flush buffer

    b = LibPigpio.ser_data_available(h)
    expect(b).to be_checked_against(0)

    e = LibPigpio.ser_write(h, ta_TEXT, ta_TEXT.bytesize)
    expect(e).to be_checked_against(0)

    e = LibPigpio.ser_write_byte(h, 0xAA)
    e = LibPigpio.ser_write_byte(h, 0x55)
    e = LibPigpio.ser_write_byte(h, 0x00)
    e = LibPigpio.ser_write_byte(h, 0xFF)

    expect(e).to be_checked_against(0)

    LibPigpio.time_sleep(0.1) # allow time for transmission

    b = LibPigpio.ser_data_available(h)
    expect_to_be_checked_against(b, ta_TEXT.bytesize + 4)

    b = LibPigpio.ser_read(h, text, ta_TEXT.bytesize)
    expect_to_be_checked_against(b, ta_TEXT.bytesize)
    text[b] = 0 if b >= 0
    expect_to_contain(String.new(text.to_slice), ta_TEXT)

    b = LibPigpio.ser_read_byte(h)
    expect_to_be_checked_against(b, 0xAA)

    b = LibPigpio.ser_read_byte(h)
    expect_to_be_checked_against(b, 0x55)

    b = LibPigpio.ser_read_byte(h)
    expect_to_be_checked_against(b, 0x00)

    b = LibPigpio.ser_read_byte(h)
    expect_to_be_checked_against(b, 0xFF)

    b = LibPigpio.ser_data_available(h)
    expect(b).to be_checked_against(0)

    e = LibPigpio.ser_close(h)
    expect(e).to be_checked_against(0)
  end

  pending "SMBus / I2C tests" { }

  it "SPI tests" do
    tx_buf = uninitialized LibC::Char[8]
    rx_buf = uninitialized LibC::Char[8]

    # this tests requires a MCP3202 on SPI channel 1

    h = LibPigpio.spi_open(1, 50_000, 0)
    expect(h).to be_checked_against(0)

    tx_buf[0] = 0x01
    tx_buf[1] = 0x80

    5.times do
      b = LibPigpio.spi_transfer(h, tx_buf, rx_buf, 3)
      expect(b).to be_checked_against(3)
      if b == 3
        LibPigpio.time_sleep(1.0)
        print "#{((rx_buf[1] & 0x0F)*256)|rx_buf[2]} "
      end
    end

    e = LibPigpio.spi_close(h)
    expect(e).to be_checked_against(0)
  end
end
