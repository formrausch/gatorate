# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gatorate/version'

spec = Gem::Specification.new do |s|
  s.name    = 'gatorate'
  s.version = Gatorate::VERSION
  s.platform = Gem::Platform::RUBY

  s.author   = ['Formrausch GmbH', 'Thomas Winkler', 'Christian Latsch']
  s.email    = 'hallo@formrausch.com'
  s.homepage = 'http://www.formrausch.com'
  s.summary  = 'Is the door open'

  s.license       = "MIT"

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.has_rdoc = false
  s.bindir = 'bin'

  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_development_dependency('mocha')

  s.add_dependency('gli','2.8.1')
  s.add_dependency('haml')
  s.add_dependency('ffi-rzmq', '1.0.3')
  s.add_dependency('celluloid-zmq')
  s.add_dependency('smart_colored')
  s.add_dependency('sinatra')
  s.add_dependency('ipaddress')
  s.add_dependency('awesome_print')
  s.add_dependency('json')
  s.add_dependency('dcell')
  s.add_dependency('reel', '~> 0.4.0')
  s.add_dependency('thin')
  s.add_dependency('http')
  s.add_dependency('colorize')
  s.add_dependency('wiringpi')
  s.add_dependency('yell')
  s.add_dependency('yell-adapters-syslog')
  s.add_dependency('rest-client')
  s.add_dependency('wiringpi')
end

