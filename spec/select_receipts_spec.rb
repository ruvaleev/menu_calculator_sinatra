# frozen_string_literal: true

require './main/select_receipts'

RSpec.describe 'Select receipts' do
  subject(:selected_receipts) do
    select_receipts(requested_receipts_count, undesired, prohibited)
  end

  let(:requested_receipts_count) { rand(2..3) }
  let(:receipts_count) { requested_receipts_count }
  let(:undesired) { Receipt::POSSIBLE_INGRIDIENTS.sample }
  let(:prohibited) { (Receipt::POSSIBLE_INGRIDIENTS - [undesired]).sample }
  let(:receipts) { create_list(:receipt, receipts_count, excluded_ingridients: [undesired, prohibited]) }

  before { receipts }

  it 'returns not more than provided count' do
    expect(selected_receipts.size).to eq(requested_receipts_count)
  end

  context 'with undesired ingridients' do
    let!(:undesired_receipts) { create_list(:receipt, rand(2..3), included_ingridients: [undesired]) }

    context 'when receipts without undesired ingridients enough' do
      it 'returns receipts without undesired ingridients' do
        expect(selected_receipts).to eq(receipts)
      end

      it "doesn't return receipts with undesired ingridients" do
        expect(selected_receipts).not_to include(*undesired_receipts)
      end
    end

    context 'when receipts without undesired ingridients not enough' do
      let(:receipts_count) { requested_receipts_count - 1 }

      it 'returns receipts with minimum receipts with undesired ingridients' do
        expect(selected_receipts).to include(*receipts)
      end

      it 'returns requested count of receipts' do
        expect(selected_receipts.size).to eq(requested_receipts_count)
      end
    end
  end

  context 'with prohibited_ingridients' do
    let(:prohibited_receipts) { create_list(:receipt, rand(2..3), included_ingridients: [prohibited]) }

    context 'when receipts without undesired ingridients enough' do
      it 'returns receipts without undesired ingridients' do
        expect(selected_receipts).to eq(receipts)
      end

      it "doesn't return receipts with undesired ingridients" do
        expect(selected_receipts).not_to include(*prohibited_receipts)
      end
    end

    context 'when receipts without undesired ingridients not enough' do
      let(:receipts_count) { requested_receipts_count - 1 }

      it 'returns receipts with minimum receipts with undesired ingridients' do
        expect(selected_receipts).to include(*receipts)
      end

      it 'returns existed count of receipts instead of requested' do
        expect(selected_receipts.size).not_to eq(requested_receipts_count)
        expect(selected_receipts.size).to eq(receipts_count)
      end
    end
  end
end
