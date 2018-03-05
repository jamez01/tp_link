[![pipeline status](https://ruby-code.com/james/tp_link/badges/master/pipeline.svg)](https://ruby-code.com/james/tp_link/commits/master)

# TP_Link
tp_link allows you to interact with TP-Link smart lights.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tp_link'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem tp_link

## Usage

#### [OPTIONAL] Create your config file at `~/.tp_link` The contents should include your username and password for Kasa/TPLink Cloud.

```
---
user: your-kasa-email@example.com
password: YourPassword
```

#### Examples:

```ruby
# You can also pass the configuration in pragmatically:
# sh=TPLink::SmartHome.new('user' => 'test@example.com',
#                          'password' => 'password123')
sh = TPLink::SmartHome.new

# Get array of TPLink Devices (currently only dimmable lights work).
sh.devices

# Find a device by name:
light = sh.find("kitchen")

# Turn light on
light.on

# Turn light off
light.off

# Dim light to 50%
light.on(50)
```

## Contributing

Bug reports and pull requests are welcome on ruby-code.com at
https://ruby-code.com/james/tp_link/

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
