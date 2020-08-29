# frozen_string_literal: true

RSpec.describe Manga::Tools::Session do
  describe '::DEFAULT_HOST' do
    subject { described_class::DEFAULT_HOST }
    it { is_expected.to eq 'https://manga-tools-server.herokuapp.com' }
  end
  describe '.new' do
    let(:session_dir) { "#{Dir.home}/.manga-tools/session" }
    subject { described_class.new }
    it do
      subject
      expect(FileTest.directory?(session_dir)).to be_truthy
    end
  end
  describe '#options=' do
    let(:options) { {} }
    let(:session) { described_class.new }
    subject { session.options = options }
    describe 'host key' do
      context 'If host is not included in the options' do
        it do
          subject
          expect(session.send(:base_url)).to eq described_class::DEFAULT_HOST
        end
      end
      context 'If the option included host' do
        let(:host) { 'localhost:3000' }
        let(:options) { { host: host } }
        it do
          subject
          expect(session.send(:base_url)).to eq "http://#{host}"
        end
      end
    end
    describe 'session_file_name key' do
      context 'If session_file_name is not included in the options' do
        it do
          subject
          expect(session.send(:session_file_name)).to eq 'session.txt'
        end
      end
      context 'If the option included session_file_name' do
        let(:session_file_name) { 'deadbeef.txt' }
        let(:options) { { session_file_name: session_file_name } }
        it do
          subject
          expect(session.send(:session_file_name)).to eq session_file_name
        end
      end
    end
  end
  describe '#get' do
    let(:path) { '/path' }
    let(:session) { described_class.new }
    let(:response) { double('faraday response') }
    let(:headers) { double('http headers') }
    let(:session_id) { 'deadbeef' }
    let(:body) { { 'message' => 'success' } }
    before do
      allow(Manga::Tools::Http).to receive(:get).and_return(response)
      allow(response).to receive(:headers).and_return(headers)
      allow(response).to receive(:body).and_return(JSON.dump(body))
      allow(headers).to receive(:[]).and_return(session_id)
      allow(session).to receive(:load).and_return(nil)
      allow(session).to receive(:store)
    end
    subject { session.get(path) }
    it { is_expected.to eq body }
  end
  describe '#post' do
    let(:path) { '/path' }
    let(:session) { described_class.new }
    let(:response) { double('faraday response') }
    let(:headers) { double('http headers') }
    let(:session_id) { 'deadbeef' }
    let(:body) { { 'message' => 'success' } }
    let(:params) { {} }
    before do
      allow(Manga::Tools::Http).to receive(:post).and_return(response)
      allow(response).to receive(:headers).and_return(headers)
      allow(response).to receive(:body).and_return(JSON.dump(body))
      allow(headers).to receive(:[]).and_return(session_id)
      allow(session).to receive(:load).and_return(nil)
      allow(session).to receive(:store)
    end
    subject { session.post(path, params) }
    it { is_expected.to eq body }
  end
end
