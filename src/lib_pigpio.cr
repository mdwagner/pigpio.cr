@[Link("pigpio")]
lib LibPigpio
  alias Int = LibC::Int
  alias UInt = LibC::UInt

  fun gpio_init = gpioInitialise : Int
  fun gpio_terminate = gpioTerminate : Void
  fun gpio_set_mode = gpioSetMode(gpio : UInt, mode : UInt) : Int
  fun gpio_get_mode = gpioGetMode(gpio : UInt) : Int
  fun gpio_set_pull_up_down = gpioSetPullUpDown(gpio : UInt, pud : UInt) : Int
  fun gpio_read = gpioRead(gpio : UInt) : Int
  fun gpio_write = gpioWrite(gpio : UInt, level : UInt) : Int
end
