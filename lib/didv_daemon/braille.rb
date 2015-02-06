module DIDV

  class Braille

    attr_reader :content,:lines

    def initialize(new_content = nil, *params)
      self.content = new_content
      @lines = []
      check_params params unless params.empty?
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

    def each_line(&block)
      @lines.each &block
    end

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

    def check_params(params)
      line_size = params.first[:lines]
      define_lines line_size if line_size.is_a? Fixnum
    end

    def define_lines(cells_by_line)
      points_by_line = cells_by_line * POINTS
      @content.each_line do |string_line|
        group_points(string_line, points_by_line).each do |line|
          @lines << normalize_line(line, points_by_line)
        end
      end
    end

    def normalize_line(line, points_by_line)
      (points_by_line - line.size).times do
        line << '0'
      end
      line
    end

    def group_points(content,size)
      cell_array = []
      tmp_content = content.gsub("\n",'').chars
      while tmp_content.any?
        cell_array << tmp_content.shift(size).join
      end
      cell_array
    end

  end

end
