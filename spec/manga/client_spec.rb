# frozen_string_literal: true

RSpec.describe Manga::Tools::Client do
  describe '.new' do
    describe 'has session object' do
      subject { described_class.new.session }
      it { is_expected.not_to be_nil }
    end
  end
  describe '#search' do
    let(:word) { '' }
    let(:options) { {} }
    before do
      allow_any_instance_of(Manga::Tools::Session).to receive(:options=)
      allow_any_instance_of(Manga::Tools::Session).to receive(:get).and_return({})
    end
    subject { described_class.new.search(word, options) }
    it { is_expected.to eq({}) }
  end
end
