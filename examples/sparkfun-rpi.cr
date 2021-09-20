require "../src/pigpio"

client = PigpioClient.new

# https://learn.sparkfun.com/tutorials/raspberry-gpio/python-rpigpio-example
client.connect do |c|
  pwm_pin = 18
  led_pin = 23
  button_pin = 17
  dc = 95

  c.set_mode(led_pin, :out)
  c.set_mode(pwm_pin, :out)
  c.set_pwm_freq(pwm_pin, 320) # lowest freq at 5 microseconds
  c.set_mode(button_pin, :in)
  c.set_pull_up_down(button_pin, :up)
  c.write(led_pin, :low)

  c.set_pwm_range(pwm_pin, 100)
  c.pwm(pwm_pin, dc)

  stop_program = false
  Signal::INT.trap { stop_program = true }

  puts "Here we go! Press Ctrl+C to exit"
  until stop_program
    if c.read(button_pin).high?
      c.pwm(pwm_pin, dc)
      c.write(led_pin, :low)
    else
      c.pwm(pwm_pin, 100 - dc)
      c.write(led_pin, :high)
      sleep 0.075
      c.write(led_pin, :low)
      sleep 0.075
    end
  end
  c.pwm(pwm_pin, 0)
end
