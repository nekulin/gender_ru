# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gender_ru/version'

Gem::Specification.new do |spec|
  spec.name          = 'gender_ru'
  spec.version       = GenderRu::VERSION
  spec.authors       = ['Maxim Dorofienko']
  spec.email         = %w(mdorfin@me.com)
  spec.description   = 'Gem tries detect gender and ethnicity by name. Supports Russian and Azerbaijanian names.'
  spec.summary       = 'Gem tries detect gender and ethnicity by name. Supports Russian and Azerbaijanian names.'
  spec.homepage      = 'https://github.com/miliru/gender_ru'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_runtime_dependency 'activesupport', '> 3.0.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec'
end
