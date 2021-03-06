require_relative '../lib/didv_daemon' unless defined?(DIDV)

describe DIDV::Braille, "new" do

  it "should return a Braille object to a nil content" do
    expect(DIDV::Braille.new(nil)).to be_a(DIDV::Braille)
  end

  it "should return a Braille object to a valid content" do
    expect(DIDV::Braille.new("100000\n")).to be_a(DIDV::Braille)
  end

  it "should raise an error to a invalid content" do
    expect{ DIDV::Braille.new("aaa") }.to raise_error("Invalid content! \"aaa\"")
  end

end

describe DIDV::Braille, "lines" do

  before(:all) do
    @text = "this is\n my braille text"
    @foo = DIDV::to_braille(@text, 10)
  end

  it "should return an array of lines" do
    expect(@foo.lines).to be_an Array
    expect(@foo.lines.empty?).to be false
  end

  it "should return an array of n size lines" do
    @foo.lines.each do |line|
      expect(line.content.size).to be(6 * 10)
    end
  end

end

describe DIDV::Braille, "to_text" do

  it "should return a EOL to a EOT" do
    br = DIDV::Braille.new('000101010101000101010101000101010101')
    expect(br.to_text).to eq("\n")
  end

  it "should return a number followed by a lowercase char" do
    br = DIDV::Braille.new('001111' + '100000' + '000010' + '100000')
    expect(br.to_text).to eq("1a")
  end

  it "should ignore flags when not followed by chars" do
    br = DIDV::Braille.new('001111' + '100000' + '000010')
    expect(br.to_text).to eq("1")
  end

end

describe DIDV::Braille, "hex" do
  it "should return the expected hex" do
    expected_hex = "8\x144\"\x00\x14\x1C\x006**&"
    br = DIDV::to_braille "life is good"
    expect(br.hex).to eq(expected_hex)
  end
end
