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

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
