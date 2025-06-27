# IdleRailsShutdown

## Installation

Add this line to your application's Gemfile:

```ruby
gem "idle_rails_shutdown", git: "https://github.com/ekroon/idle_rails_shutdown.git", branch: "main"
```

And then execute:

```bash
$ bundle install
```

## Usage

The gem works out of the box with default settings. It will monitor controller actions and shut down the application if no events are received for 1 minute.

### Configuration

You can configure the gem in an initializer:

```ruby
# config/initializers/fly_rails_shutdown.rb
FlyRailsShutdown.configure do |config|
  # How often to check if the application is healthy (default: 1 minute)
  config.check_interval = 30.seconds

  # How long to wait without events before shutting down (default: 1 minute)
  config.shutdown_threshold = 1.minute

  # Optional callable to run when the application is idle. When set, this will
  # be executed instead of sending a SIGINT to the process.
  # config.shutdown_callable = -> { system("flyctl", "machine", "suspend") }
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yourusername/fly_rails_shutdown.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
