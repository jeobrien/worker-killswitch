# Worker::Killswitch
<a title="Worker Killswitch">
    <img height="150" alt="Worker Killswitch" src="https://github.com/jeobrien/worker-killswitch/raw/master/big-red-button.png" />
</a>

A simple way to instantly stop background processes that are not critical to the core functionality of your app when systems are overloaded and your app is at risk of a user-visible outage. By pausing asynchronous jobs, you can temporarily relieve operational pressure without any impact to front end components of the app.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'worker-killswitch'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install worker-killswitch

## Configuration

```ruby
# In your ./config/initializer/worker_killswitch.rb

Sidekiq::Killswitch.configure do |config|
  config.logger = MyLogger.new # optional, defaults to Rails.logger
  config.metrics_provider = MyMetricsProvider.new # optional
end
```

Add Worker Killswitch middleware to Sidekiq:
```ruby
# In your config/initializers/sidekiq.rb
require 'worker/killswitch/middleware/load'
```
or you can load it manually:
```ruby
# In your config/initializers/sidekiq.rb

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Worker::Killswitch::Middleware::Server
  end
end
```

## Configuration
To enable the switch:
```ruby
Workers::Killswitch.enable
```

To disable the switch:
```ruby
Workers::Killswitch.disable
```

To check the current state of the switch:
```ruby
Workers::Killswitch.enabled?
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/worker-killswitch. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Killswitch project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/killswitch/blob/master/CODE_OF_CONDUCT.md).
