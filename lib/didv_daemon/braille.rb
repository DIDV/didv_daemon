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

module DIDV

  UCHARS="[A-ZÀ-ÖØ-Ý]"
  SCHARS="[,;:.'\"?!-]"
  LCHARS="[a-zà-öø-ÿ]"
  NCHARS="[0-9]"


  def self.to_braille word
    if word.match /\A(#{LCHARS})+\z/
      content = ""
      word.each_char { |char| content << char_to_braille(char) }
      Braille.new(content)
    else
      false
    end
  end

  private

  def self.char_to_braille char
    braille_yml = YAML::load_file("lib/didv_daemon/braille.yml")
    braille_yml['non_numeric'][char]
  end

end
