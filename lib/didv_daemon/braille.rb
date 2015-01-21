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
