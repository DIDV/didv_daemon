module DIDV

  # Classe responsável pela abstração do processo de escrita de texto.
  class Writer

    include BrailleUtils

    # @param filename [String] base do nome do arquivo que será gerado a partir da edição.
    def initialize(filename)
      @filename = filename
      initial_content filename
      go_to_eot
    end

    # Inclui char no texto.
    #
    # @param braille_char [String] char incluído.
    def insert_braille_char braille_char
      cells = @text.cells
      cells.insert(@index,braille_char)
      @text.content = cells.join
      increment_index
    end

    # Deleta char sob posição atual do cursor.
    def delete_braille_char
      cells = @text.cells
      cells.delete_at(@index)
      @text.content = cells.join
      decrement_index if @index == @text.cells.size
    end

    # @return [Array] linha e coluna correspondentes a posição atual do cursor.
    def index_position
      row = @index / 10
      column = @index % 10
      [row,column]
    end

    # Decrementa posição do cursor.
    def decrement_index
      @index = @index - 1 unless @index == 0
    end

    # Incrementa posição do cursor.
    def increment_index
      @index = @index + 1 unless @index == @text.cells.size
    end

    # Posiciona o cursor no final do texto.
    def go_to_eot
      @index = @text.cells.size
    end

    # @return [Boolean] se o cursor se encontra no fim do texto.
    def eot?
      @index == @text.cells.size
    end

    # Termina a linha com espaços.
    def end_of_line
      column = index_position[1]
      (10 - column ).times { insert_braille_char "000000" }
    end

    # @return [Braille] hex da linha sendo editada atualmente.
    def current_line
      row,column = index_position
      line = @text.cells[10 * row,10].join
      Braille.new(fill_line(line,60)).hex_lines.map { |hex_line| hex_line + blink_hex }
    end

    # @return [String] hex de controle para 'piscar' a posição atual do cursor.
    def blink_hex
      (0xb0 + index_position[1]).chr
    end

    # Armazena o texto editado.
    def save!
      posfix = 0
      while File.exist? "#{TEXT_DIR}/#{@filename}#{posfix}.txt"
        posfix = posfix + 1
      end
      File.open("#{TEXT_DIR}/#{@filename}#{posfix}.txt",'w') do |f|
        f.puts @text.to_text
      end
    end

    private

    # @return [Boolean] se o char é um char Braille válido.
    def valid_braille_char? braille_char
      (braille_char =~ /\A[01]{6}\z/) or
      (braille_char == "\n")
    end

    # Carrega conteúdo inicial no texto editado.
    def initial_content content
      braille_text = DIDV::to_braille(content).content
      @text = DIDV::Braille.new(fill_line(braille_text,60))
    end

  end

end
