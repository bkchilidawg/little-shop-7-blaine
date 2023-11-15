require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe "validations" do
    it { should validate_presence_of :quantity_threshold }
    it { should validate_presence_of :percentage_discount }
  end

  describe "relationships" do
    it { should belong_to :merchant }
  end

  describe "instance methods" do
    it "has_pending_invoice_items?" do
      merchant1 = Merchant.create!(name: "Electronics")
  
      item1 = Item.create!(name: "TV", description: "Something to watch on", unit_price: 100, merchant_id: merchant1.id)
      item2 = Item.create!(name: "Computer", description: "Something to code on", unit_price: 1000, merchant_id: merchant1.id)
      item3 = Item.create!(name: "CD Player", description: "Use to play music", unit_price: 1, merchant_id: merchant1.id)
      item4 = Item.create!(name: "Ipod", description: "Plays Music", unit_price: 100, merchant_id: merchant1.id)
      item5 = Item.create!(name: "Regular Charger", description: "For normal stuff", unit_price: 10, merchant_id: merchant1.id)
  
      customer1 = Customer.create!(first_name: "John", last_name: "Cena")

      invoice1 = Invoice.create!(customer_id: customer1.id, status: 2)
      invoice2 = Invoice.create!(customer_id: customer1.id, status: 2)
      invoice3 = Invoice.create!(customer_id: customer1.id, status: 1)
  
      invoice_item1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 9, unit_price: 100, status: 0) 
      invoice_item2 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 1, unit_price: 100, status: 1)
      invoice_item3 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item2.id, quantity: 2, unit_price: 1000, status: 1)
      invoice_item4 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item3.id, quantity: 3, unit_price: 1, status: 1)
      invoice_item5 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item4.id, quantity: 1, unit_price: 100, status: 1)
      invoice_item6 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item5.id, quantity: 1, unit_price: 10, status: 1) 
  
      transaction1 = Transaction.create!(credit_card_number: 111111, result: 1, invoice_id: invoice1.id)
      transaction2 = Transaction.create!(credit_card_number: 222222, result: 1, invoice_id: invoice1.id)
      transaction3 = Transaction.create!(credit_card_number: 333333, result: 1, invoice_id: invoice1.id)
      transaction4 = Transaction.create!(credit_card_number: 444444, result: 1, invoice_id: invoice1.id)

      bulk_discount1 = merchant1.bulk_discounts.create!(quantity_threshold: 5, percentage_discount: 10)
      bulk_discount2 = merchant1.bulk_discounts.create!(quantity_threshold: 15, percentage_discount: 20)

      expect(bulk_discount1.has_pending_invoice_items?).to be true
      expect(bulk_discount2.has_pending_invoice_items?).to be false
    end
  end
end