require_relative '../lib/didv_daemon' unless defined?(DIDV)

describe DIDV::InkText, "to_braille" do

  it "returns the expected braille to a lower case letters-only string" do
    ink_text = DIDV::InkText.new("my text")
    foo = "101100101111000000011110100010101101011110"
    expect( ink_text.to_braille.content ).to eq( foo )
  end

  it "returns the expected braille to numeric string" do
    ink_text = DIDV::InkText.new("123 123")
    foo = "001111100000110000100100000000001111100000110000100100"
    expect( ink_text.to_braille.content ).to eq( foo )
  end

  it "returns the expected braille to mixed string" do
    ink_text = DIDV::InkText.new("1s1 ?iT ?")
    foo = "001111100000011100001111100000000000010001010100000101011110000000010001"
    expect( ink_text.to_braille.content ).to eq( foo )
  end

  it "should ignore carriage return escapes" do
    ink_text = DIDV::InkText.new("my text\r")
    foo = "101100101111000000011110100010101101011110"
    expect( ink_text.to_braille.content ).to eq( foo )
  end

  it "should translate tabs to four spaces" do
    ink_text = DIDV::InkText.new("\t")
    foo = "000000000000000000000000"
    expect( ink_text.to_braille.content ).to eq( foo )
  end

  it "should keep new line escapes" do
    ink_text = DIDV::InkText.new("\n")
    foo = "\n"
    expect( ink_text.to_braille.content ).to eq( foo )
  end

end
