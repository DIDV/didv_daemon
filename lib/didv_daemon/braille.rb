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


  end

end
