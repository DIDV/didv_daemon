module DIDV
  DICT = YAML::load_file("lib/didv_daemon/braille.yml")
  POINTS = DICT["metadata"]["points"]
end
