require_relative '../lib/didv_daemon'

module DIDV
  module Daemon

    def post_init
      @ux = UX.new
      DIDV::draw_lines "DIDV"
      sleep 3
      DIDV::draw_lines @ux.option
    end

    def receive_data(input)
      response = @ux.get_input input[0]
      close_connection if response == "desligar"
      EventMachine.stop if response == "desligar"
    end

  end
end

EventMachine.run do
  EventMachine.start_server '127.0.0.1',9001,DIDV::Daemon
end
