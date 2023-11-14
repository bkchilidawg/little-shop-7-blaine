class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items
  has_many :invoice_items, through: :items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices
  has_many :bulk_discounts
  def items_to_ship 
    invoice_items 
    .where(status: "pending")
  end

  def top_five_customers
    Invoice.joins(:items).joins(:transactions).joins(:customer)
      .select("customers.id, customers.first_name, customers.last_name, count(customers.id) as successful_transactions")
      .where("items.merchant_id = ? and transactions.result = 0", self.id)
      .group('customers.id')
      .order(successful_transactions: :desc)
      .limit(5)
  end
  
  def self.top_five_customers
    Customer.joins(:transactions)
      .select("customers.id, customers.first_name, customers.last_name, count(transactions.*) as successful_transactions")
      .where("transactions.result = 0")
      .group('customers.id')
      .order(successful_transactions: :desc)
      .limit(5)
  end


  def disabled_items 
    Item.where("active = false and merchant_id = #{self.id}")
  end

  def enabled_items 
    Item.where("active = true and merchant_id = #{self.id}")
  end


  def top_five_items
    Item.joins(:transactions)
      .select("items.id, items.name, sum(invoice_items.unit_price * invoice_items.quantity) as revenue")
      .where("items.merchant_id = #{self.id} and transactions.result = 0")
      .group('items.id')
      .order(revenue: :desc)
      .limit(5)
  end

  def self.top_five_merchants
    Merchant.joins(:transactions)
      .select("merchants.id, merchants.name, sum(invoice_items.unit_price * invoice_items.quantity) as revenue")
      .where("transactions.result = 0")
      .group('merchants.id')
      .order(revenue: :desc)
      .limit(5)
  end

  def best_day
    Merchant.joins(:transactions)
    .select("invoices.created_at, sum(invoice_items.quantity * invoice_items.unit_price) as sales")
    .where("items.merchant_id = #{self.id} and transactions.result = 0")
    .group('invoices.created_at')
    .order("sales desc, invoices.created_at desc")
    .limit(1).first.created_at.strftime("%d %b %Y")
  end

  def self.enabled
    where(enabled: true)
  end

  def self.disabled
    where(enabled: false)
  end

  def enable
    update(enabled: true)
  end

  def disable
    update(enabled: false)
  end
end