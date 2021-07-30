require "./spec_helper"

class Globals
  class_property t2_count = 0

  class_property t3_reset = 1
  class_property t3_count = 0
  class_property t3_tick = 0
  class_property t3_on = 0.0
  class_property t3_off = 0.0

  def self.reset : Void
    t2_count = 0

    t3_reset = 1
    t3_count = 0
    t3_tick = 0
    t3_on = 0.0
    t3_off = 0.0
  end
end

Spectator.describe "LibPigpio" do
  alias LibPigpio = Pigpio::LibPigpio

  GPIO     =         25
  USERDATA = 18_249_013

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
    LibPigpio.gpio_delay(1)
    v = LibPigpio.gpio_read(GPIO)
    expect(v).to be_checked_against(1)

    LibPigpio.gpio_set_pull_up_down(GPIO, LibPigpio::PI_PUD_DOWN)
    LibPigpio.gpio_delay(1)
    v = LibPigpio.gpio_read(GPIO)
    expect(v).to be_checked_against(0)

    LibPigpio.gpio_write(GPIO, LibPigpio::PI_LOW)
    v = LibPigpio.gpio_get_mode(GPIO)
    expect(v).to be_checked_against(1)

    v = LibPigpio.gpio_read(GPIO)
    expect(v).to be_checked_against(0)

    LibPigpio.gpio_write(GPIO, LibPigpio::PI_HIGH)
    LibPigpio.gpio_delay(1)
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

    LibPigpio.time_sleep(0.5)
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

    t3_val = USERDATA

    t3cbf = LibPigpio::GpioAlertFuncExT.new do |gpio, level, tick, userdata|
      val = Box(typeof(t3_val)).unbox(userdata)
      expect(val).to eq(USERDATA)

      if Globals.t3_reset
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
    LibPigpio.gpio_set_alert_func_ex(GPIO, t3cbf, Box(typeof(t3_val)).box(t3_val))

    3.times do |t|
      LibPigpio.gpio_servo(GPIO, pw[t])
      v = LibPigpio.gpio_get_servo_pulsewidth(GPIO)
      expect(v).to be_checked_against(pw[t])

      LibPigpio.time_sleep(1)
      Globals.t3_reset = 1
      LibPigpio.time_sleep(4)
      on = Globals.t3_on
      off = Globals.t3_off
      expect((1e3*(on+off))/on).to be_checked_against(2e7/pw[t], 1)
    end
  end
end
