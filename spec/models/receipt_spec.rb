# frozen_string_literal: true

RSpec.describe Receipt, type: :model do
  it { is_expected.to validate_presence_of(:callorage) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:ingridients) }
  it { is_expected.to validate_presence_of(:title) }

  describe 'save callbacks' do
    subject(:run_callbacks) { receipt.run_callbacks(:save) }

    let(:receipt) { build(:receipt, ingridients: ingridients, callorage: 0) }
    let(:ingridients) { { carrot: carrot_quantity, onion: onion_quantity, meat: meat_quantity } }
    let(:carrot_quantity) { (100..1000).step(100).to_a.sample }
    let(:onion_quantity) { (100..1000).step(100).to_a.sample }
    let(:meat_quantity) { (100..1000).step(100).to_a.sample }
    let(:carrot_callorage) { Receipt::CALLORAGE_DICTIONARY['carrot'] * carrot_quantity / 100 }
    let(:onion_callorage) { Receipt::CALLORAGE_DICTIONARY['onion'] * onion_quantity / 100 }
    let(:meat_callorage) { Receipt::CALLORAGE_DICTIONARY['meat'] * meat_quantity / 100 }
    let(:expected_result) { carrot_callorage + onion_callorage + meat_callorage }

    it 'calls :calculate_callorage' do
      allow(receipt).to receive(:calculate_callorage)
      run_callbacks
      expect(receipt).to have_received(:calculate_callorage).once
    end

    it 'updates :callorage field with correctly calculated value' do
      expect { receipt.save }.to change(receipt, :callorage).from(0).to(expected_result)
    end
  end
end
