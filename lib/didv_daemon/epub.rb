module DIDV

  class EPub

    attr_accessor :metadata,:text

    def initialize(filename)
      @epub = load_epub(filename)
      @content_opf = load_content_opf
      @metadata = load_metadata
      load_spine
      @text = load_text
    end

    private

    def load_epub(filename)
      begin
        Zip::File.open(filename)
      rescue Exception => e
        raise "Invalid filename! #{e.message}"
      end
    end

    def content_entry_path
      begin
        container = Nokogiri::XML(@epub.read("META-INF/container.xml"))
        container.css("rootfile").first.attribute("full-path").value
      rescue Exception => e
        raise "Invalid epub file! #{e.message}"
      end
    end

    def load_content_opf
      content_entry = content_entry_path
      Nokogiri::XML(@epub.read(content_entry)).remove_namespaces!
    end

    def load_metadata
      metadata = {}
      metadata[:title] = @content_opf.css("title").text
      metadata[:author] = @content_opf.css("creator").text
      metadata
    end

    def load_text
      text = ""
      @spine.each do |item_id|
        item_path = File.dirname(content_entry_path) + "/#{item_href(item_id)}"
        text += Nokogiri::HTML(@epub.read(item_path)).text
      end
      text
    end

    def load_spine
      @spine = []
      @content_opf.css("itemref").each do |itemref|
        @spine << itemref.attribute("idref").value
      end
    end

    def item_href(item_id)
      query = "//manifest/item[@id='#{item_id}']"
      @content_opf.xpath(query).attribute("href").value
    end

  end

end
