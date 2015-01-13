# didv_daemon

Processo principal do DIDV. Contém:

* Leitor de ePub;
* Conversor texto => braille;
* Conversor braille => texto;

## Pré-requisitos

1. Ruby (rvm)
2. Bundler

## Instalação

    git clone https://github.com/DIDV/didv_daemon
    cd didv_daemon
    bundle install

## Exemplo de utilização

### ePub

meu_epub.rb:

    # supondo que o programa meu_epub.rb esta no diretorio raiz do didv_daemon
    # e que no mesmo diretorio tenho um arquivo livro.epub
    require_relative 'lib/didv_daemon'
    
    meu_epub = DIDV::EPub.new("livro.epub")
    
    puts meu_epub.metadata[:author]
    puts meu_epub.metadata[:title]
    
    # o comando abaixo imprime TODO o texto extraído do epub em um novo arquivo.
    File.open("livro.txt") do |f|
      f.puts meu_epub.text
    end
