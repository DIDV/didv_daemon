module DIDV

  class Braille

    attr_reader :content

    def initialize new_content = nil
      self.content = new_content
    end

    def content= content
      if valid? content
        @content = content
      else
        raise "Invalid content!"
      end
    end

    def cells
      cell_array = []
      tmp_content = @content.chars
      while tmp_content.any?
        cell_array << tmp_content.shift(6).join
      end
      cell_array
    end

    def each_cell &block
      cells.each &block
    end

    def self.char_to_braille
      load_dictionary
    end

    private

    def valid? content
      if content.nil? or
        ( content.delete("10").empty? and
        content.size % 6 == 0 )
        then
        true
      else
        false
      end
    end

  end

end
