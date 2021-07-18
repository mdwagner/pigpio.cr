require "./spec_helper"

Spectator.describe "LibPigpio" do
  alias LibPigpio = Pigpio::LibPigpio

  GPIO = 25

  before_all { LibPigpio.gpio_init < 0 && raise "pigpio init failed" }
  after_all { LibPigpio.gpio_terminate }

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

    t2_count = 0

    t2cb = LibPigpio::GpioAlertFuncT.new { t2_count += 1 }
    t2cb_closure = Box(typeof(t2cb)).box(t2cb)
    t2cb_f = LibPigpio::GpioAlertFuncExT.new do |gpio, level, tick, userdata|
      Box(typeof(t2cb)).unbox(userdata).call(gpio, level, tick)
    end
    LibPigpio.gpio_set_alert_func_ex(GPIO, t2cb_f, t2cb_closure)

    LibPigpio.gpio_pwm(GPIO, 0)
    dc = LibPigpio.gpio_get_pwm_dutycycle(GPIO)
    expect(dc).to be_checked_against(0)

    LibPigpio.time_sleep(0.5)
    oc = t2_count
    LibPigpio.time_sleep(2)
    f = t2_count - oc
    expect(f).to be_checked_against(0)

    LibPigpio.gpio_pwm(GPIO, 128)
    dc = LibPigpio.gpio_get_pwm_dutycycle(GPIO)
    expect(dc).to be_checked_against(128)

    oc = t2_count
    LibPigpio.time_sleep(2)
    f = t2_count - oc
    expect(f).to be_checked_against(40, 5)

    LibPigpio.gpio_set_pwm_freq(GPIO, 100)
    f = LibPigpio.gpio_get_pwm_freq(GPIO)
    expect(f).to be_checked_against(100)

    oc = t2_count
    LibPigpio.time_sleep(2)
    f = t2_count - oc
    expect(f).to be_checked_against(400, 1)

    LibPigpio.gpio_set_pwm_freq(GPIO, 1000)
    f = LibPigpio.gpio_get_pwm_freq(GPIO)
    expect(f).to be_checked_against(1000)

    oc = t2_count
    LibPigpio.time_sleep(2)
    f = t2_count - oc
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
end
