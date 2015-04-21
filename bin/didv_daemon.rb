require_relative '../lib/didv_daemon'

module DIDV
  module Daemon

    def post_init
      @ux = UX.new
      sleep 1
      @ux.entra_menu
      DIDV::send_data @ux.option if @ux.option
    end

    def receive_data(input)
      @ux.keyboard_input input.chomp
      DIDV::send_data @ux.option if @ux.option
    end

  end
end

EventMachine.run do
  EventMachine.start_server '127.0.0.1',9001,DIDV::Daemon
end
