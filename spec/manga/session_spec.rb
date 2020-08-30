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
  end
  describe '#get' do
    let(:path) { '/path' }
    let(:session) { described_class.new }
    let(:store) { spy('session store') }
    let(:response) { spy('faraday response') }
    let(:body) { { 'message' => 'success' } }
    before do
      session.instance_variable_set('@store', store)
      allow(Manga::Tools::Http).to receive(:get).and_return(response)
      allow(response).to receive(:body).and_return(body.to_json)
    end
    subject { session.get(path) }
    it { is_expected.to eq body }
    it { expect(store).to have_receive(:load) }
    it { expect(response).to have_receive(:headers) }
    it { expect(store).to have_receive(:store) }
  end
  describe '#post' do
    let(:path) { '/path' }
    let(:session) { described_class.new }
    let(:store) { spy('session store') }
    let(:response) { spy('faraday response') }
    let(:body) { { 'message' => 'success' } }
    let(:params) { {} }
    before do
      session.instance_variable_set('@store', store)
      allow(Manga::Tools::Http).to receive(:post).and_return(response)
      allow(response).to receive(:body).and_return(body.to_json)
    end
    subject { session.post(path, params) }
    it { is_expected.to eq body }
    it { expect(store).to have_receive(:load) }
    it { expect(response).to have_receive(:headers) }
    it { expect(store).to have_receive(:store) }
  end
end
