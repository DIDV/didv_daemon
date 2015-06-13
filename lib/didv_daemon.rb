$:.unshift(File.dirname(__FILE__))

module DIDV
  # container de todas as classes, modulos e demais objetos
  # componentes do DIDV.
end

require 'bundler/setup'
require 'zip'
require 'nokogiri'
require 'yaml'
require 'eventmachine'
require 'state_machine'
require 'didv_daemon/conf'
require 'didv_daemon/epub'
require 'didv_daemon/braille'
require 'didv_daemon/ink_text'
require 'didv_daemon/buzzer'
require 'didv_daemon/voice_player'
require 'didv_daemon/reader'
require 'didv_daemon/writer'
require 'didv_daemon/didv_ux'
