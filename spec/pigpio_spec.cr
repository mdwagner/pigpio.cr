require "./spec_helper"

Spectator.describe Pigpio do
  alias LibPigpio = Pigpio::LibPigpio

  # helpers
  def should_check(actual : Int, expected : Int, pc : Int = 0)
    comparison = ((actual >= (((1e2 - pc) * expected)/1e2)) && (actual <= (((1e2 + pc) * expected)/1e2)))
    expect(comparison).to be
  end

  # hooks
  before_all { LibPigpio.gpio_init < 0 && raise "pigpio init failed" }
  after_all { LibPigpio.gpio_terminate }

  # subjects
  let(gpio) { 25 }

  it "Testing pigpio C I/F" do
    expect(LibPigpio.gpio_version).not_to eq(0)

    unless LibPigpio.gpio_hardware_revision > 0
      puts "Hardware revision cannot be found or is not a valid hexadecimal number"
    end
  end

  it "Mode/PUD/read/write tests" do
    LibPigpio.gpio_set_mode(gpio, LibPigpio::PI_INPUT)
    should_check LibPigpio.gpio_get_mode(gpio), 0

    LibPigpio.gpio_set_pull_up_down(gpio, LibPigpio::PI_PUD_UP)
    LibPigpio.gpio_delay(1)
    should_check LibPigpio.gpio_read(gpio), 1

    LibPigpio.gpio_set_pull_up_down(gpio, LibPigpio::PI_PUD_DOWN)
    LibPigpio.gpio_delay(1)
    should_check LibPigpio.gpio_read(gpio), 0

    LibPigpio.gpio_write(gpio, LibPigpio::PI_LOW)
    should_check LibPigpio.gpio_get_mode(gpio), 1

    should_check LibPigpio.gpio_read(gpio), 0

    LibPigpio.gpio_write(gpio, LibPigpio::PI_HIGH)
    LibPigpio.gpio_delay(1)
    should_check LibPigpio.gpio_read(gpio), 1
  end

  it "PWM dutycycle/range/frequency tests" do
    LibPigpio.gpio_set_pwm_range(gpio, 255)
    LibPigpio.gpio_set_pwm_freq(gpio, 0)
    should_check LibPigpio.gpio_get_pwm_freq(gpio), 10

    t2 = 0

    cb = LibPigpio::GpioAlertFuncT.new { |g, l, t| t2 += 1 }

    if cb.closure?
      closure = Box(typeof(cb)).box(cb)
      fn = LibPigpio::GpioAlertFuncExT.new do |g, l, t, d|
        Box(typeof(cb)).unbox(d).call(g, l, t)
      end
      LibPigpio.gpio_set_alert_func_ex(gpio, fn, closure)
    else
      LibPigpio.gpio_set_alert_func(gpio, cb)
    end

    # closure = Box(typeof(cb)).box(cb)
    # LibPigpio.gpio_set_alert_func_ex(gpio, ->(g, l, t, d) {
    #  fn = Box(typeof(cb)).unbox(d)
    #  fn.call(g, l, t)
    # }, closure)

    LibPigpio.gpio_pwm(gpio, 0)
    dc = LibPigpio.gpio_get_pwm_dutycycle(gpio)
    should_check dc, 0

    LibPigpio.time_sleep(0.5)
    oc = t2
    LibPigpio.time_sleep(2)
    f = t2 - oc
    should_check f, 0

    LibPigpio.gpio_pwm(gpio, 128)
    dc = LibPigpio.gpio_get_pwm_dutycycle(gpio)
    should_check dc, 128

    oc = t2
    LibPigpio.time_sleep(2)
    f = t2 - oc
    should_check f, 40, 5
  end
end
