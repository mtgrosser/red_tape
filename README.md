[![Gem Version](https://badge.fury.io/rb/red_tape.svg)](https://badge.fury.io/rb/red_tape)
[![build](https://github.com/mtgrosser/red_tape/actions/workflows/build.yml/badge.svg)](https://github.com/mtgrosser/red_tape/actions/workflows/build.yml)

# RedTape

Finanzamt-compliant VAT ID validation

RedTape provides a Ruby wrapper for extended EU VAT ID validation using the German Bundeszentralamt für Steuern REST API

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
=> :own_vat_id_invalid
```
