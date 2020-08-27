# frozen_string_literal: true

RSpec.describe Manga::Tools::Http do
  describe '.connection' do
    let(:url) { URI.parse('https://www.example.com') }
    let(:session_id) { 'deadbeef' }
    subject { described_class.connection(url, session_id) }
    context 'If a session ID is specified' do
      it { is_expected.to a_kind_of(Faraday::Connection) }
      it { expect(subject.headers).to include('User-Agent', 'X-Session-ID') }
    end
    context 'If no session ID is specified' do
      let(:session_id) { nil }
      it { is_expected.to a_kind_of(Faraday::Connection) }
      it { expect(subject.headers).to include('User-Agent') }
      it { expect(subject.headers).not_to include('X-Session-ID') }
    end
  end
  describe '.get' do
    let(:url) { 'https://www.example.com' }
    let(:session_id) { 'deadbeef' }
    let(:result) { 'ok' }
    subject { described_class.get(url, session_id) }
    before { allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(result) }
    it { is_expected.to eq result }
  end
  describe '.connection_url' do
    let(:url) { URI.parse(url_string) }
    context 'no path' do
      context 'https' do
        let(:url_string) { 'https://www.example.com' }
        subject { described_class.connection_url(url) }
        it { is_expected.to eq url_string }
      end
      context 'http' do
        let(:url_string) { 'http://www.example.com' }
        subject { described_class.connection_url(url) }
        it { is_expected.to eq url_string }
      end
      context 'localhost:3000' do
        let(:url_string) { 'http://localhost:3000' }
        subject { described_class.connection_url(url) }
        it { is_expected.to eq url_string }
      end
    end
    context 'has a path part' do
      context 'https' do
        let(:url_string) { 'https://www.example.com/path/to' }
        subject { described_class.connection_url(url) }
        it { is_expected.to eq 'https://www.example.com' }
      end
      context 'http' do
        let(:url_string) { 'http://www.example.com/path/to' }
        subject { described_class.connection_url(url) }
        it { is_expected.to eq 'http://www.example.com' }
      end
      context 'localhost:3000' do
        let(:url_string) { 'http://localhost:3000/path/to' }
        subject { described_class.connection_url(url) }
        it { is_expected.to eq 'http://localhost:3000' }
      end
    end
  end
  describe '.user_agent' do
    subject { described_class.user_agent }
    it { is_expected.to eq "manga-tools #{Manga::Tools::VERSION}" }
  end
end
