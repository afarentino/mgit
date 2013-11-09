$:.unshift File.expand_path('../lib', __FILE__)
require 'mgit/version'

Gem::Specification.new do |s|
  s.name          = 'mgit'
  s.version       = MGit::VERSION
  s.license       = 'MIT'
  s.summary       = 'MGit meta repository tool'
  s.description   = 'M[eta]Git let\'s you manage multiple git repositories simultaneously'

  s.authors       = ['FlavourSys Technology GmbH']
  s.email         = 'technology@flavoursys.com'
  s.homepage      = 'http://github.com/flavoursys/mgit'

  s.require_paths = ['lib']
  s.files         = Dir.glob('lib/**/*.rb')
  s.executables   = ['mgit']

  s.add_dependency 'colorize'
  s.add_dependency 'highline'
  s.add_dependency 'xdg'
end
