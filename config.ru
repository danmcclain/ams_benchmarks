# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
use StackProf::Middleware, enabled: true, mode: :cpu, interval: 1000, save_every: 5
run Rails.application
