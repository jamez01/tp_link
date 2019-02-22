# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'tp_link'
  s.version     = '0.0.4'
  s.summary     = 'TPLink smarthome library'
  s.description = 'Control various TPLink smart home devices.'
  s.authors     = ['James Paterni', 'Ian MOrgan']
  s.email       = 'tp_link@ruby-code.com'
  s.files = Dir.glob('./lib/**/*.rb')
  # s.executables = ['tplink']
  s.add_runtime_dependency 'faraday', '~> 0.13', '>= 0.13.1'
  s.add_runtime_dependency 'faraday_middleware', '~> 0.12', '>= 0.12.2'
  s.homepage =
    'https://ruby-code.com/james/tp_link'
  s.license = 'MIT'
end
