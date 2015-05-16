require 'daemons'

script = "#{File.dirname(__FILE__)}/didv_daemon.rb"
options = {
  app_name: "didv_daemon",
  dir_mode: :normal,
  dir: "/home/didv/pid",
  log_dir: "/home/didv/log",
  log_output: true
}

Daemons.run(script, options)
