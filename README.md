# Activerecord::StringEnum

Make ActiveRecord 4's Enum store as strings instead of integers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-string-enum'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-string-enum

## Usage

    class Task < ActiveRecord::Base
        extend ActiveRecord::StringEnum
    
        str_enum :status, [:running, :finished]
    end

## Contributing

1. Fork it ( https://github.com/phusion/activerecord-string-enum/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
