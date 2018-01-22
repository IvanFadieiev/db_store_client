require 'eventmachine'
require 'yaml'
require_relative './data_processing.rb'

Dir[File.dirname(__FILE__) + '/servers/*.rb'].each { |file| load file }
Dir[File.dirname(__FILE__) + '/support/*.rb'].each { |file| load file }

Process.daemon(true, true) if ENV['APP_ENV'].eql?('production')

CreatePid.for(file: __FILE__, pid: Process.pid)

EventMachine.run do
  Signal.trap('INT')  { EventMachine.stop }
  Signal.trap('TERM') { EventMachine.stop }

  EventMachine.start_server(ENV['SOCKET_ADDRESS']['INITIAL'], ENV['SOCKET_PORT']['INITIAL'], ReseiveInitialData)
end
