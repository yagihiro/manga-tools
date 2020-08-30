# frozen_string_literal: true

RSpec.describe Manga::Tools::SessionStore do
  describe '.new' do
    let(:session_dir) { "#{Dir.home}/.manga-tools/session" }
    subject { described_class.new }
    it do
      subject
      expect(FileTest.directory?(session_dir)).to be_truthy
    end
  end
  describe '#session_file_name' do
    let(:store) { described_class.new }
    subject { store.instance_variable_get(:@session_file_name) }
    context 'If session_file_name is specified' do
      let(:session_file_name) { 'deadbeef.txt' }
      before { store.session_file_name = session_file_name }
      it { is_expected.to eq session_file_name }
    end
    context 'If the session_file_name is not specified' do
      it { is_expected.to eq 'session.txt' }
    end
  end
  describe '#store' do
    let(:current_session_id) { 'hoge' }
    let(:session_id) { 'deadbeef' }
    let(:store) { described_class.new }
    before { store.session_file_name = 'session-test.txt' }
    after { File.delete(store.session_file_path) }
    subject { store.store(session_id) }
    context 'If a session already exists' do
      before { File.open(store.session_file_path, 'w') { |f| f.write(current_session_id) } }
      it { expect { subject }.not_to change { File.read(store.session_file_path) } }
      it do
        subject
        expect(File.read(store.session_file_path)).to eq current_session_id
      end
    end
    context 'If the session does not already exist' do
      it do
        subject
        expect(File.read(store.session_file_path)).to eq session_id
      end
    end
  end
  describe '#load' do
    let(:store) { described_class.new }
    before { store.session_file_name = 'session-test.txt' }
    subject { store.load }
    context 'If a session already exists' do
      let(:session_id) { 'deadbeef' }
      before { File.open(store.session_file_path, 'w') { |f| f.write(session_id) } }
      after { File.delete(store.session_file_path) }
      it { is_expected.to eq session_id }
    end
    context 'If the session does not already exist' do
      it { is_expected.to eq nil }
    end
  end
end
