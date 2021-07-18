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
    puts LibPigpio.gpio_version
    puts LibPigpio.gpio_hardware_revision
  end

  context "Mode/PUD/read/write tests" do
    it "set mode, get mode" do
      LibPigpio.gpio_set_mode(gpio, LibPigpio::PI_INPUT)
      actual = LibPigpio.gpio_get_mode(gpio)
      should_check(actual, 0, pc: 0)
    end

    it "set pull up down, read" do
      LibPigpio.gpio_set_pull_up_down(gpio, LibPigpio::PI_PUD_UP)
      LibPigpio.gpio_delay(1)
      actual = LibPigpio.gpio_read(gpio)
      should_check(actual, 1, pc: 0)
    end
  end
end
