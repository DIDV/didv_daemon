module DIDV

  class Reader

    attr_accessor :text

    def initialize(path)
      if epub? path
        @text = InkText.new(EPub.new(path).text)
      else
        @text = InkText.new(File.read(path))
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
