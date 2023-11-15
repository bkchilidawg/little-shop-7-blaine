class BulkDiscount < ApplicationRecord
  validates :percentage_discount, presence: true, numericality: { greater_than: 0 }
  validates :quantity_threshold, presence: true, numericality: { greater_than: 0 }
                        
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items

  def has_pending_invoice_items?
    BulkDiscount.joins(:invoice_items).where("invoice_items.status = 1 and invoice_items.quantity >= bulk_discounts.quantity_threshold and bulk_discounts.id = #{id}").count > 0
  end
end

