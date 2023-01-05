<h1><img src="logo.svg" width="200" alt="getargv"></h1>

[![Ruby](https://github.com/getargv/getargv_ruby/actions/workflows/main.yml/badge.svg)](https://github.com/getargv/getargv_ruby/actions/workflows/main.yml)
[![Gem Version](https://badge.fury.io/rb/getargv.svg)](https://badge.fury.io/rb/getargv)

This gem allows you to query the arguments of other processes on macOS.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add getargv

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install getargv

## Usage

```ruby
Getargv.get_argv_of_pid_as_string(some_process_id) #=> "arg0\x00arg1"
Getargv.get_argv_of_pid_as_array(some_process_id) #=> ["arg0","arg1"]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Ruby code goes in the dir `lib/getargv_ruby`, C code goes in the dir `ext/getargv_ruby`.  To experiment with that code, run `bin/console` for an interactive prompt.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release[origin]`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/getargv/getargv_ruby.

## License

The gem is available as open source under the terms of the [BSD 3-clause License](https://opensource.org/licenses/BSD-3-Clause).
