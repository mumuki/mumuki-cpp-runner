# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version_hook'

Gem::Specification.new do |spec|
  spec.name          = 'mumuki-cpp-runner'
  spec.version       =  CppVersionHook::VERSION
  spec.authors       = ['Franco Leonardo Bulgarelli']
  spec.email         = ['franco@mumuki.org']
  spec.summary       = 'Cpp Runner for Mumuki'
  spec.homepage      = 'http://github.com/mumuki/mumuki-cpp-server'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/**']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'mumukit', '~> 2.17'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'mumukit-bridge', '~> 3.0'
end



