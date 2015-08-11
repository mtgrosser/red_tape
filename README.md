# RedTape

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/red_tape`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

In your Gemfile:

```ruby
gem 'red_tape'
```

## Usage

```ruby

# quick syntax
RedTape.valid?('DE123456789', 'ATU33864707') => true

# if you want detailed error messages from the Bundeszentralamt
validator = RedTape.validator('DE123456789', 'FOO', company_name: 'Red Bull GmbH', city: 'Fuschl am See')

validator.valid?
=> false

validator.status
=> :invalid_country
```
