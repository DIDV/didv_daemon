module DIDV

  # Classe que abstrai o processo de leitura de arquivo de texto ou ePub.
  class Reader

    # início do batch de texto atual.
    attr_accessor :offset
    # quantidade de caracteres por lote de texto.
    attr_accessor :limit
    # caminho do arquivo contendo metadado de último lote de texto lido.
    attr_reader :offset_path

    # @param path [String] caminho do arquivo de texto.
    # @param restart [Boolean] se o arquivo deve ser lido início.
    # @param limit [Integer] quantidade de caracteres por lote.
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

    # @return [String] próximo lote de caracteres.
    def batch
      batch = InkText.new(@ink_text.text[@offset,@limit])
      update_offset unless batch.text.empty?
      batch
    end

    # @return [String] lote de caracteres anterior.
    def rewind_batch
      @offset = @offset - (2*@limit) unless @offset == 0
      batch = InkText.new(@ink_text.text[@offset,@limit])
      update_offset unless batch.text.empty?
      batch
    end

    # Atualiza posição do offset para início do lote.
    def update_offset
      @offset += @limit unless @offset + @limit > @ink_text.text.size
      File.open(@offset_path,'w') {|f| f.puts @offset}
    end

    private

    # Abre arquivo a partir da posição de offset armazenada no arquivo de offset.
    def load_current_offset
      if File.exist? @offset_path
        @offset = File.read(@offset_path).to_i
      else
        @offset = 0
      end
    end

    # Verifica se o arquivo a ser aberto é um epub.
    def epub? path
      begin
        Zip::File.open(path).entries.map { |a| a.name }.include? "META-INF/container.xml"
      rescue
        false
      end
    end

  end

end
