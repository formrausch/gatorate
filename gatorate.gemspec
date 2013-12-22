# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','gatorate','version.rb'])

spec = Gem::Specification.new do |s|
  s.name = 'gatorate'
  s.version = Gatorate::VERSION
  s.author = 'Formrausch'
  s.email = 'hallo@formrausch.com'
  s.homepage = 'http://formrausch.com.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Is the door open'

  s.files = %w(
bin/gatorate-prepare
bin/gatorate-install
bin/gatorate
lib/gatorate/version.rb
lib/gatorate.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['gatorate.rdoc']
  s.rdoc_options << '--title' << 'gatorate' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'gatorate' << 'gatorate-prepare' << 'gatorate-install'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_development_dependency('mocha')
  s.add_runtime_dependency('gli','2.8.1')
  s.add_runtime_dependency('haml')
  s.add_runtime_dependency('smart_colored')
  s.add_runtime_dependency('sinatra')
  s.add_runtime_dependency('ipaddress')
  s.add_runtime_dependency('awesome_print')
  s.add_runtime_dependency('json')
  s.add_runtime_dependency('dcell', '0.15.0')
  s.add_runtime_dependency('thin')
  s.add_runtime_dependency('wiringpi')
end

