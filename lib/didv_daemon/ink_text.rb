module DIDV

  def self.to_braille ink_text
    utils = InkText.new ink_text
    utils.to_braille
  end

  class InkText

    def initialize text
      @text = text
      @dictionary = YAML::load_file("lib/didv_daemon/braille.yml")
      @flags = {
        number: false
      }
    end

    def to_braille
      content = ""
      @text.each_char { |char| content << char_to_braille(char) }
      Braille.new(content)
    end

    private

    def char_to_braille char
      if is_a_number? char

        if @flags[:number]
          @dictionary['numbers'][char]
        else
          @flags[:number] = true
          "#{@dictionary['braille']['number']}#{@dictionary['numbers'][char]}"
        end

      else

        @flags[:number] = false

        if is_a_capital? char
          # return capital code plus char code
          "#{@dictionary['braille']['uppercase']}#{@dictionary['non_numeric'][char.downcase]}"
        else
          @dictionary['non_numeric'][char]
        end

      end
    end

    def is_a_number? char
      if char =~ /\A[0-9\u20AC$=+-]\z/
        true
      else
        false
      end
    end

    def is_a_capital? char
      if char =~ /\A[A-ZÀ-ÖØ-Ý]\z/
        true
      else
        false
      end
    end
  end

end
