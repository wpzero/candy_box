# CandyBox

Candy box includes special include and extend function and can add config on class or module.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'candy_box'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install candy_box

## Usage

```ruby
  module HiMixin
    include CandyBox

    write_candy_config do
        version 0.1
        word 'hello world'
    end

    def say_hi
        "say: #{candy_config.word}"
    end

    def version
        candy_config.version
    end

    def sleep
        'sleep'
    end
  end

  HiMixin.candy_config.version # 0.1
  HiMixin.candy_config.word # 'hello world'

```
include HiMinxin through candy_box and rewrite these these config

```ruby
  class Person
    include CandyBox
    add_candy HiMixin, version: 0.2, word: '你好世界', only: [:say_hi, :version]
  end

  Persion.candy_config.word # '你好世界'
  Persion.candy_config.version # 0.2
  p = Persion.new
  p.say_hi # 'say: 你好世界'
  p.version # 0.2
  p.sleep # NoMethodError
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/candy_box. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

