module DIDV
  class VoicePlayer

    def initialize
      load_voice_dictionary
    end

    def speak!(message)
      if dictionary_has(message) and found_file(message)
        `aplay #{@dictionary[message]}`
      end
    end

    def dictionary_has(message)
    end

    def found_file(message)
    end

  end
end
