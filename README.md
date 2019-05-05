# Worker Killswitch

A simple way to instantly kill background processes that are not critical to the core functionality of your app. The number one priority is keeping the app up and running, whether it is already overloaded and potentially heading towards an outage or in the midst of one and needing to recover. The worker killswitch offers a way to instantly disable background workers in times of high load to prevent a user-visible outage of frontend components.

It implement the ability to pause a queue by adding a middleware to each worker config. This middleware checks each job as it is popped off the queue to see if the switch has been turned on. If so, it waits 5 seconds and then checks again, polling the cache each time. When it is turned off, the jobs keep getting processed. So that we aren’t having all workers polling at exactly the same time, we have added a random additional 0..1 second wait to each sleep. If there are any cache connectivity issues, the switch fails open.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'worker-killswitch'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install worker-killswitch

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/worker-killswitch. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Killswitch project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/killswitch/blob/master/CODE_OF_CONDUCT.md).
