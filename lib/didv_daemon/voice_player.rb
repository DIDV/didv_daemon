module DIDV
  class VoicePlayer

    def initialize
      @dictionary = VOICE_DICT
    end

    def speak!(message)
      Thread.new do
        if dictionary_has(message) and found_file(message)
          `omxplayer #{File.join(VOICE_DIR,@dictionary[message])} &> /dev/null`
        end
        self.kill
      end
    end

    def dictionary_has(message)
      @dictionary.keys.include? message
    end

    def found_file(message)
      File.exist? File.join(VOICE_DIR,@dictionary[message])
    end

  end
end
