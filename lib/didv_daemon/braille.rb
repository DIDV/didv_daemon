module DIDV

  class Braille

    attr_reader :content

    def initialize(new_content = nil, *params)
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
      cells.each block
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

    private

    def fill_line(line,size)
      line << "0" * ( size  - ( line.size % size ) )
    end

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
        grouped_points << content_chars.shift(points).join
      end
      grouped_points
    end


  end

end
