require_relative '../lib/didv_daemon' unless defined?(DIDV)

describe DIDV::InkText, "new" do

  it "returns the expected braille to a lower case letters-only string" do
    ink_text = DIDV::InkText.new("my text")
    expected = "101100101111000000011110100010101101011110"
    expect( ink_text.to_braille.content ).to eq(expected)
  end

  it "returns the expected braille to numeric string" do
    ink_text = DIDV::InkText.new("123 123")
    expected = "001111100000110000100100000000001111100000110000100100"
    expect( ink_text.to_braille.content ).to eq(expected)
  end

end
