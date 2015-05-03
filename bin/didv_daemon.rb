require_relative '../lib/didv_daemon'

module DIDV

  class Daemon < EM::Connection

    attr_reader :queue

    def initialize(q)
      @queue = q
      @ux = DIDV::UX.new
      @ux.get_hexes.each do |hex|
        @queue.push(hex)
      end
    end

    def receive_data(data)
      @ux.get_input(data[0])
      @ux.get_hexes.each do |hex|
        p hex.bytes.map{ |h| ( '0' * ( 6 % h.to_s(2).size ) ) + h.to_s(2) }
        @queue.push(hex)
      end
    end

  end

  class DisplayConnection < EM::Connection
    attr_reader :queue

    def initialize(q)
      @queue = q

      send_data DIDV::to_braille("DIDV").hex_lines[0]
      sleep 3

      cb = Proc.new do |msg|
        p msg
        send_data(msg)
        q.pop &cb
      end

      q.pop &cb
    end

  end

end

EM.run do
  q = EM::Queue.new
  EM.connect('127.0.0.1',9002,DIDV::DisplayConnection,q)
  EM.start_server('127.0.0.1',9001,DIDV::Daemon,q)
end
