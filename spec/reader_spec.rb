require_relative '../lib/didv_daemon' unless defined?(DIDV)

describe DIDV::Reader, "batch" do

  before(:all) do
    @rd = DIDV::Reader.new("spec/fixtures/valid.epub")
  end

  after(:all) do
    `rm #{@rd.offset_path}`
  end

  it "should return an empty offset" do
    expect(@rd.offset).to eq(0)
  end

  it "should update the offset" do
    @rd.offset = 1
    expect(@rd.offset).to eq(1)
  end

  it "should return the default limit" do
    expect(@rd.limit).to eq(1024)
  end

  it "should update the limit" do
    @rd.limit = 1
    expect(@rd.limit).to eq(1)
  end

  it "should update the offset after a valid batch request" do
    @rd.batch
    expect(@rd.offset).to eq(2)
  end

end
