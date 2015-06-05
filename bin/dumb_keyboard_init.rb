require 'daemons'

script = "#{File.dirname(__FILE__)}/../tmp/dumb_keyboard.rb"
options = {
  app_name: "dumb_keyboard",
  dir_mode: :normal,
  dir: "/home/didv/pid",
  log_dir: "/home/didv/log",
  log_output: true
}

Daemons.run(script, options)
