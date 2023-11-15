class InvoiceItem < ApplicationRecord
  belongs_to :invoice, dependent: :destroy
  belongs_to :item, dependent: :destroy

enum status: { packaged: 0, pending: 1, shipped: 2 }

  def item_name
    self.item.name
  end

  def applied_discount
      item.merchant.bulk_discounts
        .where("quantity_threshold <= ?", quantity)
        .order(percentage_discount: :desc)
        .first
  end

  def discounted_revenue
    if quantity && unit_price
      if applied_discount.nil?
        quantity * unit_price
      else
        discounted_price = unit_price * (1 - applied_discount.percentage_discount / 100.0)
        (quantity * discounted_price).to_i
      end
    end
  end
  
end