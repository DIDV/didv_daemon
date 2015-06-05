module DIDV

  # dicionario ASCII <-> Braille
  DICT = YAML::load_file("#{File.dirname(__FILE__)}/braille.yml")

  # dicionario ASCII -> Voz
  VOICE_DICT = YAML::load_file("#{File.dirname(__FILE__)}/voice.yml")

  # quantidade de pinos por cela Braille
  POINTS = DICT["metadata"]["points"]

  # diretorio de armazenamento de arquivos de texto
  TEXT_DIR = "/media/usb/"

end
