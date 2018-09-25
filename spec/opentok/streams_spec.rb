require 'opentok/opentok'
require 'opentok/version'
require 'opentok/streams'
require 'opentok/stream'
require 'opentok/stream_list'

require 'spec_helper'

describe OpenTok::Streams do
  before(:each) do
    now = Time.parse('2017-04-18 20:17:40 +1000')
    allow(Time).to receive(:now) { now }
  end

  let(:api_key) { '123456' }
  let(:api_secret) { '1234567890abcdef1234567890abcdef1234567890' }
  let(:session_id) { 'SESSIONID' }
  let(:stream_id) { 'STREAMID' }
  let(:opentok) { OpenTok::OpenTok.new api_key, api_secret }
  let(:streams) { opentok.streams}

  subject { streams }

  it { should be_an_instance_of OpenTok::Streams }
  it 'raise an error on nil session_id' do
    expect {
      streams.all(nil)
    }.to raise_error(ArgumentError)
  end
  it 'raise an error on empty session_id' do
    expect {
      streams.all('')
    }.to raise_error(ArgumentError)
  end
  it 'get all streams information', :vcr => { :erb => { :version => OpenTok::VERSION + "-Ruby-Version-#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"} } do
    all_streams = streams.all(session_id)
    expect(all_streams).to be_an_instance_of OpenTok::StreamList
    expect(all_streams.total).to eq 2
  end
  it 'get specific stream information', :vcr => { :erb => { :version => OpenTok::VERSION + "-Ruby-Version-#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"} } do
    stream = streams.this_one(session_id, stream_id)
    expect(stream).to be_an_instance_of OpenTok::Stream
    expect(stream.videoType).to eq 'camera'
    expect(stream.layoutClassList.count).to eq 1
    expect(stream.layoutClassList.first).to eq "full"
    expect(stream.id).not_to be_nil
  end
end