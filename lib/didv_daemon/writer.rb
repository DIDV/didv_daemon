module DIDV

  class Writer

    include BrailleUtils

    # attr_accessor :text

    def initialize(filename)
      @filename = filename
      initial_content filename
      @index = @text.cells.size
    end

    def insert_braille_char braille_char
      cells = @text.cells
      cells.insert(@index,braille_char)
      @text.content = cells.join
      increment_index
    end

    def delete_braille_char
      cells = @text.cells
      cells.delete_at(@index)
      @text.content = cells.join
      decrement_index if @index == @text.cells.size
    end

    def index_position
      row = @index / 10
      column = @index % 10
      [row,column]
    end

    def decrement_index
      @index = @index - 1 unless @index == 0
    end

    def increment_index
      @index = @index + 1 unless @index == @text.cells.size
    end

    def current_line
      row,column = index_position
      line = @text.cells[10 * row,10].join
      Braille.new(fill_line(line,60))
    end

    def blink_current_line
      cells = current_line.cells
      row,column = index_position
      cells[column] = "000000"
      Braille.new(cells.join)
    end

    def save!
      posfix = 0
      while File.exist? "tmp/#{@filename}#{posfix}.txt"
        posfix = posfix + 1
      end
      File.open("tmp/#{@filename}#{posfix}.txt",'w') do |f|
        f.puts @text.to_text
      end
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
