module DIDV

  class Reader

    attr_accessor :offset,:limit
    attr_reader :offset_path

    def initialize(path,restart=false,limit=1024)
      if epub? path
        @ink_text = InkText.new(EPub.new(path).text)
      else
        @ink_text = InkText.new(File.read(path))
      end
      @limit = limit
      @offset_path = File.join(File.dirname(path),".#{File.basename(path)}.didv")
      if restart
        @offset = 0
      else
        load_current_offset
      end
    end

    def batch
      batch = InkText.new(@ink_text.text[@offset,@limit])
      update_offset unless batch.text.empty?
      batch
    end

    def rewind_batch
      @offset = @offset - (2*@limit) unless @offset == 0
      batch = InkText.new(@ink_text.text[@offset,@limit])
      update_offset unless batch.text.empty?
      batch
    end

    def update_offset
      @offset += @limit unless @offset + @limit > @ink_text.text.size
      File.open(@offset_path,'w') {|f| f.puts @offset}
    end

    private

    def load_current_offset
      if File.exist? @offset_path
        @offset = File.read(@offset_path).to_i
      else
        @offset = 0
      end
    end

    def epub? path
      begin
        Zip::File.open(path).entries.map { |a| a.name }.include? "META-INF/container.xml"
      rescue
        false
      end
    end

  end

end
