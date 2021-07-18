require "./spec_helper"

Spectator.describe Pigpio do
  alias LibPigpio = Pigpio::LibPigpio

  # helpers
  def should_check(actual : Int, expected : Int, pc : Int)
    comparison = ((actual >= (((1e2 - pc) * expect)/1e2)) && (actual <= (((1e2 + pc) * expect)/1e2)))
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
    should_check LibPigpio.gpio_get_mode(gpio), 0, 0

    LibPigpio.gpio_set_pull_up_down(gpio, LibPigpio::PI_PUD_UP)
    LibPigpio.gpio_delay(1)
    should_check LibPigpio.gpio_read(gpio), 1, 0

    LibPigpio.gpio_set_pull_up_down(gpio, LibPigpio::PI_PUD_DOWN)
    LibPigpio.gpio_delay(1)
    should_check LibPigpio.gpio_read(gpio), 0, 0

    LibPigpio.gpio_write(gpio, LibPigpio::PI_LOW)
    should_check LibPigpio.gpio_get_mode(gpio), 1, 0

    should_check LibPigpio.gpio_read(gpio), 0, 0

    LibPigpio.gpio_write(gpio, LibPigpio::PI_HIGH)
    LibPigpio.gpio_delay(1)
    should_check LibPigpio.gpio_read(gpio), 1, 0
  end
end
