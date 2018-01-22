require 'rack'
require 'logger'
require 'figaro'
require_relative './rack_apps/socket_client_run'
require_relative './lib/support/create_pid'

env = ENV['APP_ENV'] || 'development'
Figaro.application = Figaro::Application.new(environment: env, path: './config/application.yml')
Figaro.load

Process.daemon(true, true) if ENV['APP_ENV'].eql?('production')

App = Rack::Builder.new do
  use Rack::CommonLogger, Logger.new('log/app.log')
  use Rack::Deflater
  use Rack::Reloader

  map '/send_initial_data' do
    run SocketClientRun
  end
end

CreatePid.for(file: __FILE__, pid: Process.pid)

run App
