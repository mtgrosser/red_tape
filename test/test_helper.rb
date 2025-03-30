$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'pathname'

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require 'red_tape'

require 'debug'
require 'webmock/minitest'
require 'minitest/autorun'
