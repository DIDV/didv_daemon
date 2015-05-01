require_relative '../lib/didv_daemon'

module DIDV

  class Daemon < EM::Connection

    attr_reader :queue

    def initialize(q)
      @queue = q
      @ux = DIDV::UX.new
    end

    def receive_data(data)
      @ux.get_input(data[0])
      @ux.get_lines.each do |line|
        p line.bytes
        @queue.push(line)
      end
    end

  end

  class DisplayConnection < EM::Connection
    attr_reader :queue

    def initialize(q)
      @queue = q

      cb = Proc.new do |msg|
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
