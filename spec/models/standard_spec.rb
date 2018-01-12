require 'rails_helper'

describe Standard do
  it 'has valid factory' do
    obj = create :standard
    expect(obj).to be_valid
  end

  context 'relations' do
    it { is_expected.to have_many(:standard_emphases) }
  end

  context 'scopes' do
    describe '.bilingual' do
      before { create :standard, is_language_progression_standard: true }

      it { expect(described_class.bilingual.count).to eq 1 }
    end
  end

  describe '.search_by_name' do
    let(:alt_name) { 'a-synonym' }
    let(:name) { 'test-std' }
    let(:standard_1) { create :standard, alt_names: [alt_name.upcase], grades: ['grade 10'], subject: 'ela' }
    let(:standard_2) { create :standard, alt_names: %w(fake), grades: ['grade 10'], name: name.upcase, subject: 'ela' }

    it { expect(described_class.search_by_name('qwerty').first).to be_nil }

    it 'searches by alt_name' do
      standard_1
      expect(described_class.search_by_name(alt_name).first).to eq standard_1
    end

    it 'searches by name' do
      standard_2
      expect(described_class.search_by_name(name).first).to eq standard_2
    end
  end

  describe '#emphasis' do
    let!(:emphasis) { create :standard_emphasis, grade: grade, standard: standard }
    let(:grade) { 'grade' }
    let(:standard) { create :standard }

    subject { standard.emphasis grade }

    it { is_expected.to eq emphasis.emphasis }

    context 'when emphasis with such grade does not exist' do
      let(:emphasis_value) { 'another-value' }
      let!(:another_emphasis) { create :standard_emphasis, emphasis: emphasis_value, grade: nil, standard: standard }

      before { emphasis.update grade: 'another-grade' }

      it { is_expected.to eq another_emphasis.emphasis }
    end

    context 'when grade is nil' do
      let(:grade) { nil }

      it { is_expected.to eq emphasis.emphasis }
    end
  end
end
