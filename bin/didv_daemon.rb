require_relative '../lib/didv_daemon'

module DIDV

  class Daemon < EM::Connection

    attr_reader :queue

    def initialize(q,ux)
      @queue = q
      @ux = ux
      @ux.get_hexes.each { |hex| @queue.push(hex) }
      @last_representation = "ler"
      send_data 'waiting'
    end

    def receive_data(data)
      data.chomp!
      if is_valid? data
        @ux.get_input(data)
        p @ux.get_representation
        unless @last_representation == @ux.get_representation
          @ux.get_hexes.each { |hex| @queue.push(hex) }
          if @ux.menu == 'desligar'
            @queue.push('F4')
          end
	  @last_representation = @ux.get_representation
	end
      end
      send_data 'waiting'
    end

    def is_valid?(data)
      data =~ /([favesb]|[01]{6})/
    end

  end

  class DisplayConnection < EM::Connection
    attr_reader :queue

    def initialize(q)
      @queue = q
    end

    def receive_data(data)
      if data == 'waiting'
        @queue.pop { |msg| send_data msg }
      end
    end

    def unbind
      EM.stop
    end

  end

end

EM.run do
  q = EM::Queue.new
  ux = DIDV::UX.new
  EM.connect('127.0.0.1',9002,DIDV::DisplayConnection,q)
  EM.start_server('127.0.0.1',9001,DIDV::Daemon,q,ux)
end
