class InvoiceItem < ApplicationRecord
  belongs_to :invoice, dependent: :destroy
  belongs_to :item, dependent: :destroy

enum status: { packaged: 0, pending: 1, shipped: 2 }

  def item_name
    self.item.name
  end

  def applied_discount
    if quantity && unit_price
      item.merchant.bulk_discounts.where("quantity_threshold <= ?", quantity).order(percentage_discount: :desc).first
    end
  end

  def discounted_revenue
    if quantity && unit_price
      if applied_discount.nil?
        quantity * unit_price
      else
        ((100 - applied_discount.percentage_discount).to_f/100 * quantity * unit_price).to_i
      end
    end
  end
end