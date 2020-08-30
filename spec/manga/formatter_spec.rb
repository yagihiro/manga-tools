# frozen_string_literal: true

RSpec.describe Manga::Tools::Formatter do
  describe '.display' do
    context 'search command' do
      let(:command) { :search }
      before { allow(described_class).to receive(:display_search).and_return('ok') }
      subject { described_class.display(command) }
      it { is_expected.to eq 'ok' }
    end
    context 'follow command' do
      let(:command) { :follow }
      before { allow(described_class).to receive(:display_follow).and_return('ok') }
      subject { described_class.display(command) }
      it { is_expected.to eq 'ok' }
    end
    context 'follow-list command' do
      let(:command) { :follow_list }
      before { allow(described_class).to receive(:display_follow_list).and_return('ok') }
      subject { described_class.display(command) }
      it { is_expected.to eq 'ok' }
    end
  end
end
