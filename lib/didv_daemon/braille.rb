module DIDV

  module BrailleUtils
    def fill_line(line,size)
      unless (line.size % size == 0) and (line.size > 0)
        line << "0" * ( size  - ( line.size % size ) )
      end
      line
    end
  end

  def self.draw_lines(text)
    to_braille(text).each_line { |l| puts "#{ l.to_text.chars.join("    ") }\n#{l.draw_cells}\n" }
  end

  class Braille

    include BrailleUtils

    attr_accessor :content

    def initialize(new_content = "", *params)
      self.content = new_content
    end

    def content=(content)
      if valid? content
        @content = content
      else
        raise "Invalid content!"
      end
    end

    def cells
      group_points @content,POINTS
    end

    def each_cell(&block)
      cells.each &block
    end

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

    def hex
      cells.map { |cell| "00#{cell}".to_i(2).chr }.join
    end

    def each_line(size=10, &block)
      lines.each &block
    end

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
          when "downcase"
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

    def draw_text(text)
      draw_cells to_braille(text).cells
    end

    def draw_lines(text)
      to_braille(text).each_line { |l| puts "#{draw_cells l.cells}\n" }
    end

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

    # def fill_line(line,size)
    #   unless (line.size % size == 0) and (line.size > 0)
    #     line << "0" * ( size  - ( line.size % size ) )
    #   end
    #   line
    # end

    private

    def valid?(content)
      if content.nil? or
        ( content.delete("10\n").empty? and
        content.gsub("\n",'').size % POINTS == 0 )
      then
        true
      else
        false
      end
    end

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

    def signed_cell(cell)
      pins = cell.chars
      pins.each_index do |index|
        pins[index] = pins[index] == '1' ? 'o' : '-'
      end
      pins
    end


  end

end
