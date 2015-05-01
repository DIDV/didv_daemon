require_relative '../lib/didv_daemon'

module DIDV
  class Daemon < EM::Connection

    def initialize(queue)
      @ux = UX.new
      
      @queue.push(DIDV::to_braille("DIDV").hex)
      foo = Proc.new do |msg|
        # send_data(msg)
        puts msg
        queue.pop &foo
      end
      queue.pop &foo
    end

    def post_init
      send_data(DIDV::draw_lines @ux.option)
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
