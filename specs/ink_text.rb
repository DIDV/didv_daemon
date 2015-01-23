require_relative '../lib/didv_daemon' unless defined?(DIDV)

describe DIDV::InkText, "to_braille" do

  it "returns the expected braille to a lower case letters-only string" do
    ink_text = DIDV::InkText.new("my text")
    foo = "101100101111000000011110100010101101011110"
    bar = ink_text.to_braille.content
    puts bar
    expect( bar ).to eq( foo )
  end

  it "returns the expected braille to numeric string" do
    ink_text = DIDV::InkText.new("123 123")
    expected = "001111100000110000100100000000001111100000110000100100"
    expect( ink_text.to_braille.content ).to eq(expected)
  end

  it "returns the expected braille to mixed string" do
    ink_text = DIDV::InkText.new("Texto com muitas c015as!!!")
    expected = "001111100000110000100100000000001111100000110000100100"
    expect( ink_text.to_braille.content ).to eq(expected)
  end

end
