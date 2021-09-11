# pigpio.cr

Crystal binding to [pigpio C library](https://abyz.me.uk/rpi/pigpio/cif.html)

## Installation

1. Add the dependency to your `shard.yml`:

```yml
dependencies:
  pigpio:
    github: mdwagner/pigpio.cr
```

2. Run `shards install`

## Usage

```crystal
require "pigpio"

client = PigpioClient.new

# configuration (if needed)
client.config.buffer_millis = 200
client.config.mem_alloc_mode = :pagemap

# block usage (recommended)
client.connect do |connection|
  connection.on_alert(5) { puts "hello world!" }
end

# manual usage
client.start
connection = client.connection
connection.on_alert(5) { puts "hello world!" }
client.stop
```

## Development

Early days, but I have all the bindings created and tested against Pigpio C's test suite (converted to Crystal). Pretty much all future changes will be for the Client & Connection.

## Contributing

1. Fork it (<https://github.com/mdwagner/pigpio.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [mdwagner](https://github.com/mdwagner) - creator and maintainer
