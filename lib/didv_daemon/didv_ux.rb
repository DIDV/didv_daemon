# DIDV User Experience class

module DIDV

  class UX

    attr_accessor :line_index, :options, :filename

    # Maquina de Estados

    state_machine :menu, initial: :principal do

      after_transition on: [:seleciona_principal,:seleciona_ler_modo], do: :load_options
      after_transition on: :seleciona_ler, do: :load_valid_files_list
      after_transition on: :seleciona_do_inicio, do: :load_text_to_read_from_beginning
      after_transition on: :seleciona_continuar, do: :load_text_to_read

      event :seleciona_ler do
        transition [:principal,:do_inicio,:continuar] => :ler
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
      event :seleciona_ler_modo do
        transition :ler => :ler_modo
      end
      event :seleciona_continuar do
        transition :ler_modo => :continuar
      end
      event :seleciona_do_inicio do
        transition :ler_modo => :do_inicio
      end

    end

     def initialize
       super
       load_options
    end

    def get_input input # tratamento de entrada de dados
      case input
      when 'a' #avanca
        case menu
        when 'do_inicio','continuar' then line_forth
        else next_option
        end
      when 'v' #volta
        case menu
        when 'do_inicio','continuar' then line_back
        else last_option
        end
      when 'e' #enter
        case menu
        when 'ler'
          @filename = "./tmp/" + option[2..-1]
          seleciona_ler_modo
        when 'principal','ler_modo'
          self.send "seleciona_#{option.gsub(" ","_")}"
        end
      when 's' #esc
        case menu
        when 'ler','escrever' then seleciona_principal
        when 'ler_modo','do_inicio','continuar' then seleciona_ler
        end
      end
      DIDV::draw_lines option;
      menu
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

    # options: array de coisas que podem ser mandadas para a linha braille

    # options sao as opcoes possiveis de acordo com a maquina de estados
    def load_options
      @options = menu_transitions.map { |foo| foo.to.gsub("_"," ") }
    end

    # options sao os arquivos validos no local de costume
    def load_valid_files_list
      @options = Dir.glob('./tmp/*.{txt,epub}').map { |f| "& #{File.basename(f)}" }
    end

    # abre o texto que sera lido
    def load_text_to_read
      @text = Reader.new(@filename)
      load_batch_lines
    end

    # abre o texto que sera lido do inicio
    def load_text_to_read_from_beginning
      @text = Reader.new(@filename,true)
      load_batch_lines
    end

    # options sao as linhas do novo batch
    def load_batch_lines
      @options = @text.batch.to_braille.lines.map { |l| l.to_text }
      @line_index = 0
    end

    # options sao as linhas do batch anterior
    def load_rewind_batch_lines
      @options = @text.rewind_batch.to_braille.lines.map { |l| l.to_text }
      @line_index = @options.size
    end

    # avanca linha de leitura
    def line_forth
      # se nao for a ultima linha...
      if @line_index < @options.size
        next_option
        @line_index = @line_index + 1
      # se for...
      else
        load_batch_lines
      end
    end

    # volta para a linha de leitura anterior
    def line_back
      # se nao for a primeira linha...
      if @line_index > 0
        last_option
        @line_index = @line_index - 1
      #se for...
      else
        load_rewind_batch_lines
        last_option
        @line_index = @options.size - 1
      end
    end

  end
end
