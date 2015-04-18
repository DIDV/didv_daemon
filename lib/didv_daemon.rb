$:.unshift(File.dirname(__FILE__))

require 'bundler/setup'
require 'zip'
require 'nokogiri'
require 'yaml'
require 'state_machine'
require 'didv_daemon/conf'
require 'didv_daemon/epub'
require 'didv_daemon/braille'
require 'didv_daemon/ink_text'
require 'didv_daemon/element'
require 'didv_daemon/didv_ux'

module DIDV

  def self.draw_text(text)
    draw_cells to_braille(text).cells
  end

  def self.draw_cells(cells)
    signed_cells = []
    cells.each { |cell| signed_cells << signed_cell(cell) }
    draw = ""
    (0..2).each do |line|
      signed_cells.each do |signed_cell|
        draw << "#{signed_cell[line]} #{signed_cell[line+3]}  "
      end
      draw << "\n"
    end
    draw
  end


  def self.signed_cell(cell)
    pins = cell.chars
    pins.each_index do |index|
      pins[index] = pins[index] == '1' ? 'o' : '-'
    end
    pins
  end

end
