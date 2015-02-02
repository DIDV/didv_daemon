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

describe DIDV::Braille, "lines" do

  before(:all) do
    @foo = DIDV::to_braille("this is\n my braille text", 7)
  end

  it "should return an array of lines" do
    expect(@foo.lines).to be_an Array
    expect(@foo.lines.empty?).to be false
  end

  it "should return an array of n size lines" do
    @foo.lines.each do |line|
      expect(line.size).to be 42
    end
  end

end
