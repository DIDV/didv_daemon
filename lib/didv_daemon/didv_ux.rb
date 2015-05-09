module DIDV

  # Classe de Experiência de Usuário do DIDV.
  #
  # Contém a máquina de estados controlada pelo teclado Braille que define as linhas
  # Braille que serão exibidas no display Braille, e condições especiais de exibição
  # dessas linhas.
  class UX

    # Maquina de Estados
    state_machine :menu, initial: :principal do

      after_transition on: [:seleciona_principal,:seleciona_ler_modo], do: :load_options
      after_transition on: :seleciona_ler, do: :load_valid_files_list
      after_transition on: :seleciona_do_inicio, do: :load_text_to_read_from_beginning
      after_transition on: :seleciona_continuar, do: :load_text_to_read

      # ler
      event :seleciona_ler do
        transition [:principal,:do_inicio,:continuar] => :ler
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

      # escrever
      event :seleciona_escrever do
        transition :principal => :escrever
      end
      event :seleciona_escrevendo do
        transition [:escrever,:salvar] => :escrevendo
      end
      event :seleciona_salvar do
        transition :escrevendo => :salvar
      end

      event :seleciona_desligar do
        transition :principal => :desligar
      end

      event :seleciona_principal do
        transition [:ler,:escrever,:salvar] => :principal
      end


    end

    def initialize
       super
       load_options
    end

    # @return [String] hex pra ser despachado.
    def get_hexes
      case menu
      when "ler"
        @filelist.first[:line].hex_lines
      when "escrevendo"
        @writer.current_line
      else
        option.hex_lines
      end
    end

    # Tratamento de entrada de dados.
    #
    # @param input [String] dado de entrada.
    def get_input input

      case input

      # avancar
      when 'a'
        case menu
        when 'do_inicio',
             'continuar' then line_forth
        when 'escrevendo' then next_char
        when 'ler' then @filelist.rotate!
        else next_option
        end

      # voltar
      when 'v'
        case menu
        when 'do_inicio',
             'continuar' then line_back
        when 'escrevendo' then last_char
        when 'ler' then @filelist.rotate! -1
        else last_option
        end

      # fim
      when 'f'
        case menu
        when 'escrevendo' then end_of_text
        end

      # enter
      when 'e'
        case menu

        when 'ler'
          @filename = @filelist.first[:file]
          seleciona_ler_modo

        when 'principal',
             'ler_modo'
             self.send "seleciona_#{@options.first.gsub(" ","_")}"

        when 'escrever'
          @writer = Writer.new('nota')
          @options = ['nota']
          seleciona_escrevendo

        when 'escrevendo' then end_of_line

        when 'salvar' then save_action

        end

      # backspace
      when 'b'
        case menu
        when 'escrevendo' then delete_char
        end

      # esc
      when 's'
        case menu
        when 'ler','escrever' then seleciona_principal
        when 'ler_modo',
             'do_inicio',
             'continuar' then seleciona_ler
        when 'escrevendo'
          save_options
          seleciona_salvar
        end

      # inputs de dados
      else
        case menu
        when 'escrevendo' then insert_char(input)
        end
      end

    end

    # @return [String] opção selecionada atualmente.
    def option
      DIDV::to_braille(@options.first)
    end

    private

    # Seleciona próxima opção.
    def next_option
      @options << @options.shift
    end

    # Seleciona opção anterior.ss
    def last_option
      @options.unshift(@options.pop)
    end

    # Carrega vetor 'options' com as transições possíveis para a máquina de estados.
    def load_options
      @options = menu_transitions.map { |foo| foo.to.gsub("_"," ") }
    end

    # Carrega o vetor 'filelist' com os arquivos legíveis no diretório de textos
    def load_valid_files_list

      @filelist = []

      Dir.glob("#{TEXT_DIR}/**/*.{txt,epub}").each do |f|

        filename = "& " + File.basename(f)
        DIDV::to_braille(filename).each_line do |line|
          @filelist << { line: line, file: f }
        end

      end

      unless @filelist.any?
        seleciona_principal
      end
    end

    # Carrega texto que será lido a partir da última posição.
    def load_text_to_read
      @text = Reader.new(@filename)
      load_batch_lines
    end

    # Carrega o texto que será lido a partir do início.
    def load_text_to_read_from_beginning
      @text = Reader.new(@filename,true)
      load_batch_lines
    end

    # Carrega o próximo batch de texto no vetor 'options'
    # e posiciona o line_index no início do batch.
    def load_batch_lines
      @options = @text.batch.to_braille.lines.map { |l| l.to_text }
      @line_index = 0
    end

    # Carrega o batch de texto anterior no vetor 'options' e
    # posiciona o line_index no fim do batch.
    def load_rewind_batch_lines
      @options = @text.rewind_batch.to_braille.lines.map { |l| l.to_text }
      @line_index = @options.size
    end

    # Avança para próxima linha de leitura.
    def line_forth

      @line_index +=  1

      # se nao for a ultima linha...
      if @line_index < @options.size
        next_option

      # se for...
      else
        load_batch_lines

      end
    end

    # Volta para última linha lida.
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


    # escrever

    # Avança cursor para próxima posição durante edição de texto.
    def next_char
      @writer.increment_index
    end

    # Retorna cursor para posição anterior durante edição de texto.
    def last_char
      @writer.decrement_index
    end

    # Posiciona cursor no fim do texto durante edição de texto.
    def end_of_text
      @writer.go_to_eot
    end

    # Insere salto de linha durante edição de texto.
    def end_of_line
      @writer.end_of_line
    end

    # Apaga char sob o cursor durante edição de texto.
    def delete_char
      @writer.delete_braille_char
    end

    # Insere char na posição atual do cursor, avançando em uma posição todos chars
    # posteriores, durante edição de texto.
    def insert_char(braille_char)
      @writer.insert_braille_char braille_char
    end

    # Carrega o vetor 'options' com as opções de armazenamento do texto editado.
    def save_options
      @options = [ 'salvar', 'nao salvar', 'cancelar' ]
    end

    # Executa a opção de armazenamento selecionada.
    def save_action
      case @options.first
      when 'salvar'
        @writer.save!
        seleciona_principal
      when 'nao salvar'
        seleciona_principal
      else
        seleciona_escrevendo
      end
    end

  end
end
