# DIDV User Experience class

module DIDV

  def self.send_data(data)
    puts DIDV::to_braille(data).each_line { |l| puts l.content }
  end

  class UX

    attr_accessor :line_index

    state_machine :menu, initial: :principal do

      after_transition on: :seleciona_principal, do: :load_options
      after_transition on: :seleciona_ler, do: :load_valid_files_list
      after_transition on: :seleciona_ler_texto, do: :load_text_to_read

      event :seleciona_ler do
        transition [:principal,:ler_texto] => :ler
      end
      event :seleciona_escrever do
        transition :principal => :escrever
      end
      event :seleciona_desligar do
        transition :principal => :desligar
      end
      event :seleciona_principal do
        transition [:ler,:escrever] => :principal
      end
      event :seleciona_ler_texto do
        transition :ler => :ler_texto
      end

    end

     def initialize
       super
       load_options
    end

    def get_input input
      case input
      when 'a' #avanca
        case menu
        when 'ler_texto' then line_forth
        else next_option
        end
      when 'v'
        case menu
        when 'ler_texto' then line_back
        else last_option
        end
      when 'e' #enter
        case menu
        when 'principal' then self.send "seleciona_#{option}"
        when 'ler' then seleciona_ler_texto
        end
      when 's' #esc
        case menu
        when 'ler','escrever' then seleciona_principal
        when 'ler_texto' then seleciona_ler
        end
      end
    end

    def option
      @options.first
    end

    private

    def next_option
      @options << @options.shift
    end

    def last_option
      @options.unshift(@options.pop)
    end

    def load_options
      @options = menu_transitions.map { |foo| foo.to }
    end

    def load_valid_files_list
      @options = Dir.glob('./tmp/*.{txt,epub}')
    end

    def load_text_to_read
      @text = Reader.new(option,false,1000)
      load_batch_lines
    end

    def load_batch_lines
      @options = @text.batch.to_braille.lines.map { |l| l.to_text }
      @line_index = 0
    end

    def load_rewind_batch_lines
      @options = @text.batch.to_braille.lines.map { |l| l.to_text }
      @line_index = @options.size
    end

    def line_forth
      next_option
    end

    def line_back
      last_option
    end

  end

end
