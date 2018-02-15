# frozen_string_literal: true

require 'logger'
require 'faraday'
require 'net/https'
require 'json'
require 'faraday_middleware'
require 'yaml'
require 'json'
require 'securerandom'

require 'tp_link/errors.rb'
require 'tp_link/config.rb'
require 'tp_link/light.rb'
require 'tp_link/api.rb'



# Generates the configuration used by the tplink cloud API
