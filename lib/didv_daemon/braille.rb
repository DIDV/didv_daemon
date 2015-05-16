module DIDV

  # módulo contendo métodos utilizados por diferentes classes,
  # relativos a manipulação de texto braille.
  module BrailleUtils

    # método que completa uma linha braille com espaços, tornando-o
    # adequado à linha braille.
    #
    # @param line [String] String de 1s e 0s representando os pinos Braille
    # @param size [Integer] a quantidade de pinos Braille da linha Braille
    # @return [String] a linha completa
    def fill_line(line,size)
      unless (line.size % size == 0) and (line.size > 0)
        line << "0" * ( size  - ( line.size % size ) )
      end
      line
    end


    # @param content [String] conteúdo de texto Braille.
    # @return [Boolean] se o conteúdo é válido ou não.
    def valid_content?(content)
      if content.nil? or
        ( content.delete("10\n").empty? and
        content.gsub("\n",'').size % POINTS == 0 )
      then
        true
      else
        false
      end
    end

  end

  # método que desenha no terminal a representação do texto Braille em pinos.
  def self.draw_lines(text)
    to_braille(text).each_line { |l| puts "#{ l.to_text.chars.join("    ") }\n#{l.draw_cells}\n" }
  end

  # classe de texto Braille.
  class Braille

    include BrailleUtils

    # String contendo o texto braille em pinos.
    attr_accessor :content

    # @param new_content [String] conteúdo (pinos e saltos de linha) do novo texto Braille
    def initialize(new_content = "", *params)
      self.content = new_content
    end

    # Atualiza conteúdo do texto Braille
    #
    # @param content [String] novo conteúdo Braille
    def content=(content)
      if valid_content? content
        @content = content
      else
        raise "Invalid content! #{content.inspect}"
      end
    end

    # @return [Array] vetor de celas braille
    def cells
      group_points @content,POINTS
    end

    # Itera vetor de celas Braille no bloco informado como argumento
    #
    # @param block [Proc] bloco que processará as celas Braille
    def each_cell(&block)
      cells.each &block
    end

    # @param size [Integer] quantidade de celas Braille por linha Braille
    # @return [Array] vetor de linhas braille
    def lines(size=10)
      content = @content.split("\n")
      pins_size = 6 * size

      # fill ended lines with spaces
      content.map! { |l| l = fill_line(l,pins_size)  }
      content = content.join.chars

      # split in lines
      lines = []
      lines << Braille.new(content.shift(6*size).join) until content.empty?
      lines
    end

    # @return [Array] vetor de representação em hexadecimais das celas Braille
    def hex
      cells.map { |cell| "00#{cell}".to_i(2).chr }.join
    end

    # @return [Array] vetor de linhas Braille em formato hexadecimal
    def hex_lines
      lines.map { |line| line.hex }
    end

    # Processa vetor de linhas braille através do bloco informado como argumento.
    #
    # @param size [Integer] quantidade de celas na linha Braille
    # @param block [Proc] bloco que processa as linhas Braille
    def each_line(size=10, &block)
      lines.each &block
    end

    # @return [InkText] versão ASCII do texto Braille.
    def to_text
      text = ""
      braille_cells = cells
      flag = nil

      until braille_cells.empty?
        cell = braille_cells.shift

        if cell == "\n"
          text << "\n"
        elsif (cell == "000101") and (cell + braille_cells[0..4].join == DICT['EOT'])
            text << "\n"
            braille_cells.shift(5)
        else
          chr = DICT.key cell
          unless chr
            next_cell = braille_cells.shift
            chr = DICT.key(cell+next_cell)
          end
          case chr
          when "number"
            flag="number"
          when "uppercase"
            if flag == "upcase_char"
              flag = "upcase_word"
            else
              flag = "upcase_char"
            end
          when "lowercase"
            flag = nil
          else
            new_chr = chr
            case flag
            when "number" then new_chr = DICT['numbers'].key(cell)
            when "upcase_char"
              new_chr = chr.upcase
              flag = nil
            when "upcase_word" then new_chr = chr.upcase
            when " " then flag=nil
            end
            text << new_chr if new_chr
          end
        end
      end
      text
    end

    # Desenha texto ASCII em pinos Braille no terminal.
    #
    # @param text [String] Texto ASCII.
    def draw_text(text)
      draw_cells to_braille(text).cells
    end

    # Desenha texto ASCII em linhas Braille no terminal.
    #
    # @param text [String] Texto ASCII.
    def draw_lines(text)
      to_braille(text).each_line { |l| puts "#{draw_cells l.cells}\n" }
    end

    # @return [String] versão em pinos Braille das celas do objeto Braille.
    def draw_cells
      signed_cells = []
      cells.each { |cell| signed_cells << signed_cell(cell) }
      draw = ""
      (0..2).each do |line|
        signed_cells.each do |signed_cell|
          draw << "#{signed_cell[line]} #{signed_cell[line+3]}  "
        end
        draw << "\n"
      end
      draw
    end

    private

    # Divide o conteúdo em um array de pinos
    #
    # @param content [String] conteúdo de texto Braille
    # @param  points [Integer] quantidade de pinos por elemento
    def group_points(content,points)
      content_chars = content.chars
      grouped_points = []
      while( content_chars.any? )
        if content_chars.first == "\n"
          grouped_points << content_chars.shift
        else
          grouped_points << content_chars.shift(points).join
        end
      end
      grouped_points
    end

    # @param cell [String] cela Braille.
    # @return [String] cela Braille desenhada, com - no lugar dos 0s e 'o' no lugar dos 1s.
    def signed_cell(cell)
      pins = cell.chars
      pins.each_index do |index|
        pins[index] = pins[index] == '1' ? 'o' : '-'
      end
      pins
    end


  end

end
