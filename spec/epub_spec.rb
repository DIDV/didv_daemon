require_relative '../lib/didv_daemon' unless defined?(DIDV)

describe DIDV::EPub, "new" do

  it "returns an DIDV::EPub when opens a valid epub file" do
    book = "spec/fixtures/valid.epub"
    expect(DIDV::EPub.new(book)).to be_a(DIDV::EPub)
  end

  it "raise error when trying to open an inexistent file" do
    message = "Invalid filename! File inexistent.epub not found"
    expect { DIDV::EPub.new("inexistent.epub") }.to raise_error(message)
  end

  it "raise error when trying to open an invalid file" do
    book = "spec/fixtures/invalid.epub"
    message = "Invalid epub file! No such file or directory - META-INF/container.xml"
    expect { DIDV::EPub.new(book) }.to raise_error(message)
  end
end
