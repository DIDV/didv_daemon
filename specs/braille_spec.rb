require_relative '../lib/didv_daemon' unless defined?(DIDV)

describe DIDV::Braille, "new" do

  it "should return a Braille object to a valid content" do
    expect(DIDV::Braille.new(nil)).to be_a(DIDV::Braille)
  end

  it "should return a Braille object to a nil content" do
    expect(DIDV::Braille.new("100000\n")).to be_a(DIDV::Braille)
  end

  it "should raise an error to a invalid content" do
    expect{ DIDV::Braille.new("aaa") }.to raise_error("Invalid content!")
  end

end
