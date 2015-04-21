module DIDV

  def self.to_braille(ink_text, size=nil)
    text = InkText.new ink_text
    text.to_braille size
  end

  class InkText

    attr_accessor :text

    def initialize(text)
      @text = text.gsub(" \n "," \n").gsub(/\n\ +/,"\n");
      @flags = {
        number: false
      }
    end

    def to_braille(size=nil)

       @text_food = @text.gsub("\t","    ")
      last_char_was_a_number = false
      content=""

      until @text_food.empty?

        word = self.shift_word
        unless word.empty?
          if word =~ /\A[A-ZÀ-ÖØ-Ý]{2,}\z/
            content << DICT['uppercase'] * 2
            word.downcase!
          end
        else
          word = self.shift_char
        end
        word.each_char do |chr|

          case chr
          when "\n"
            content << chr
          when " "
            content << "000000"
            last_char_was_a_number = false
          when /[\u20AC\$\=\+\-\.\,]/
            content << DICT[chr]
          when /[0-9]/
            unless last_char_was_a_number
              content << DICT['number']
              last_char_was_a_number = true
            end
            content << DICT['numbers'][chr]
          when /([[:alpha:]]|[[:punct:]])/
            if chr =~ /\A[A-ZÀ-ÖØ-Ý]\z/
              content << DICT['uppercase']
            elsif last_char_was_a_number
              content << DICT['lowercase']
            end
            content << DICT[chr.downcase] if DICT[chr.downcase]
            last_char_was_a_number = false
          end

        end

      end

      Braille.new(content.gsub(/\n{3,}/,DICT['EOT'] + "\n"))

    end

    def shift_word
      word = @text_food.match(/\A\b[[:alnum:]]+\b/).to_s
      @text_food = @text_food[word.size..-1]
      word
    end

    def shift_char
      chr = @text_food[0]
      @text_food = @text_food[1..-1]
      chr
    end

  end

end
