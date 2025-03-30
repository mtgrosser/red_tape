# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'red_tape/version'

Gem::Specification.new do |spec|
  spec.name          = "red_tape"
  spec.version       = RedTape::VERSION
  spec.authors       = ["Matthias Grosser"]
  spec.email         = ["mtgrosser@gmx.net"]

  spec.summary       = %q{Finanzamt-compliant VAT ID validation}
  spec.description   = %q{Extended validation using the German Bundeszentralamt für Steuern XML RPC API}
  spec.homepage      = "https://github.com/mtgrosser/red_tape"

  spec.files         = Dir['{lib}/**/*.rb', 'LICENSE', 'README.md', 'CHANGELOG', 'Rakefile']
  spec.require_paths = %w[lib]
  
  spec.required_ruby_version = '>= 3.0.0'

  spec.add_dependency 'xmlrpc'
end
