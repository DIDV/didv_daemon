require_relative '../lib/didv_daemon'

module DIDV

  # lib/display.rb

  class Display

    def send_hex(hex)
      data = packetize_data(hex)
      send_data datas
    end

    def packetize_data(data)
      "@#{data}A"
    end

    def send_data(data)
      puts "\ndata:"
      p data.chars.join(" ")
    end

    def valid?(data)
      data.size == 10
    end

  end

  # bin/display_daemon.rb

  module DisplayDaemon

    def post_init
      @display = Display.new
    end

    def receive_data(input)
      @display.send_hex input if @display.valid? input
    end

  end
end

EventMachine.run do
  EventMachine.start_server '127.0.0.1',9002,DIDV::DisplayDaemon
end
