require 'daemons'

script = "#{File.dirname(__FILE__)}/didv_daemon.rb"
options = {
  app_name: "didv_daemon",
  log_dir: "/home/didv",
  log_output: true
}

Daemons.run(script, options)
