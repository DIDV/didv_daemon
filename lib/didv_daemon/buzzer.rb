module DIDV

  # Classe controladora do Buzzer.
  class Buzzer

    attr_accessor :buzz_time

    # @param buzz_time [Fixnum] duração do sinal sonoro.
    def initialize(buzz_time)
      @buzz_time = buzz_time
      prepare_port
    end

    # Configura duty cicle do PWM na porta GPIO 18, de modo a produzir
    # sinal sonoro através do Buzzer.
    #
    def buzz!
      `gpio pwm 1 120`
      sleep @buzz_time
      stop_buzz
    end

    private

    # Configura a porta GPIO 18 como PWM com 2kHz de frequência.
    #
    def prepare_port
      `gpio export 1 out`
      `gpio mode 1 pwm`
      `gpio pwm-ms`
      `gpio pwmr 240`
      `gpio pwmc 40`
    end

    # Altera o duty cicle do PWM na porta GPIO 18, de modo que o
    # sinal efetivamente gerado seja um nível lógico baixo.
    #
    def stop_buzz
      `gpio pwm 1 0`
    end

  end
end
