$:.unshift(File.dirname(__FILE__))

require 'bundler/setup'
require 'zip'
require 'nokogiri'
require 'yaml'
require 'didv_daemon/conf'
require 'didv_daemon/epub'
require 'didv_daemon/braille'
require 'didv_daemon/ink_text'
