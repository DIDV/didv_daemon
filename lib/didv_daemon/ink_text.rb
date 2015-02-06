module DIDV

  def self.to_braille(ink_text, size=nil)
    text = InkText.new ink_text
    text.to_braille size
  end

  class InkText

    def initialize(text)
      @text = text
      @flags = {
        number: false
      }
    end

    def to_braille(size=nil)
      content = ""
      @text.each_char do |char|
        if is_literal? char
          content << char
        else
          unless is_ignorable? char
            braille_char = char_to_braille(char)
            unless braille_char.nil?
              content << braille_char
            end
          end
        end
      end
      unless size.nil?
        Braille.new(content, lines: size)
      else
        Braille.new(content)
      end
    end

    private

    def char_to_braille(char)
      if is_a_number? char

        if @flags[:number]
          DICT['numbers'][char]
        else
          @flags[:number] = true
          "#{DICT['number']}#{DICT['numbers'][char]}"
        end

      else

        @flags[:number] = false

        if is_a_capital? char
          # return capital code plus char code
          "#{DICT['uppercase']}#{DICT[char.downcase]}"
        else
          DICT[char]
        end

      end
    end

    def is_ignorable?(char)
      if char =~ /\r/
        true
      else
        false
      end
    end

    def is_literal?(char)
      if char =~ /\n/
        true
      else
        false
      end
    end

    def is_a_number?(char)
      if char =~ /\A[0-9\u20AC$=+-]\z/
        true
      else
        false
      end
    end

    def is_a_capital?(char)
      if char =~ /\A[A-ZÀ-ÖØ-Ý]\z/
        true
      else
        false
      end
    end
  end

end
