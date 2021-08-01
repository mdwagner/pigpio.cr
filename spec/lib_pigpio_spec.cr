require "./spec_helper"

class Globals
  class_property t2_count = 0

  class_property t3_reset = 1
  class_property t3_count = 0
  class_property t3_tick : UInt32 = 0
  class_property t3_on = 0.0
  class_property t3_off = 0.0

  class_property t5_count = 0

  def self.reset : Void
    t2_count = 0

    t3_reset = 1
    t3_count = 0
    t3_tick = 0
    t3_on = 0.0
    t3_off = 0.0

    t5_count = 0
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
end
