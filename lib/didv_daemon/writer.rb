module DIDV

  class Writer

    include BrailleUtils

    attr_accessor :text

    def initialize(filename)
      @filename = filename
      initial_content filename
      @index = @text.cells.size - 1
    end

    def append_braille_char braille_char
      @text.content << braille_char if valid_braille_char?(braille_char)
      @index = @index + 1
    end

    def delete_braille_char
      @text.cells.last.size.times { @text.content.chop! }
      @index = @index - 1
    end

    def index_position
      row = @index / 10
      column = @index % 10
      [row,column]
    end

    def current_line
      @row,@column = index_position
      line = @text.cells[10 * @row,(@column+1)].join
      Braille.new(fill_line(line,60))
    end

    private

    def valid_braille_char? braille_char
      braille_char =~ /\A[01]{6}\z/
    end

    def initial_content content
      braille_text = DIDV::to_braille(content).content
      @text = DIDV::Braille.new(fill_line(braille_text,60))
    end

  end

end
