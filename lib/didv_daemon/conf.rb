module DIDV
  DICT = YAML::load_file("#{File.dirname(__FILE__)}/braille.yml")
  POINTS = DICT["metadata"]["points"]
end
