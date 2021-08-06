# frozen_string_literal: true

def select_receipts(receipts_count, undesired, prohibited)
  desired_receipts =
    Receipt.where.not('ingridients ?| array[:ingridients_list]',
                      ingridients_list: [prohibited, undesired].flatten).limit(receipts_count)

  undesired_receipts_count = receipts_count - desired_receipts.size
  return desired_receipts if undesired_receipts_count.zero?

  undesired_receipts =
    Receipt.where('ingridients ?| array[:ingridients_list]',
                  ingridients_list: [undesired].flatten).limit(undesired_receipts_count)

  desired_receipts | undesired_receipts
end
