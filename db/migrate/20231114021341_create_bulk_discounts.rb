class CreateBulkDiscounts < ActiveRecord::Migration[6.0]
  def change
    create_table :bulk_discounts do |t|
      t.references :merchant, foreign_key: true
      t.integer :percentage_discount
      t.integer :quantity_threshold

      t.timestamps
    end
  end
end
