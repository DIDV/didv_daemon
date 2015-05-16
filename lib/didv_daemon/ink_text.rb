module DIDV


  # @param ink_text [String] texto que será convertido em Braille.
  # @param size [Integer] quantidade de celas da linha Braille.
  def self.to_braille(ink_text, size=nil)
    text = InkText.new ink_text
    text.to_braille size
  end

  # Classe de textos 'tinta' (ASCII) conversíveis para texto Braille.
  class InkText

    # Texto 'tinta'.
    attr_accessor :text

    # @param text [String] texto 'tinta'.
    def initialize(text)
      @text = text.gsub(" \n "," \n").gsub(/\n\ +/,"\n");
      @flags = {
        number: false
      }
    end

    # @param size [Integer] quantidade de celas da linha Braille.
    # @return [Braille] texto Braille.
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
            content << DICT['numbers'][chr] if DICT['numbers'][chr]
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

    # Identifica a próxima palavra do texto que será 'consumido' durante a conversão
    # para Braille, removendo-a para ser processada.
    #
    # @return [String] palavra removida do fluxo 'text_food' para processamento.
    def shift_word
      word = @text_food.match(/\A\b[[:alnum:]]+\b/).to_s
      @text_food = @text_food[word.size..-1]
      word
    end

    # Identifica o próximo char do texto que será 'consumido' durante a conversão
    # para Braille, removendo-o para ser processado.
    #
    # @return [String] char removida do fluxo 'text_food' para processamento.
    def shift_char
      chr = @text_food[0]
      @text_food = @text_food[1..-1]
      chr
    end

  end

end
