# frozen_string_literal: true

class CreateReceipts < ActiveRecord::Migration[6.1]
  def change
    create_table :receipts do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.jsonb :ingridients, null: false, default: {}
      t.integer :callorage, null: false, default: 0

      t.timestamps null: false
    end

    add_index :receipts, :title
    add_index :receipts, :callorage
    add_index :receipts, :ingridients, using: :gin
  end
end
