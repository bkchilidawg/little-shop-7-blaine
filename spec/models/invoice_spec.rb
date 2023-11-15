require "rails_helper"

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it { should belong_to(:customer) }
    it { should have_many(:transactions) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
  end

  
  describe "#instance methods" do
  describe "not_complete" do
    it "shows all the invoices marked as a status of cancelled (0) or in progress (1) and
    is ordered by created_at " do
      customer1 = Customer.create(first_name: "Patrick", last_name: "Star")
    
      invoice1 = Invoice.create(status: 0, customer_id: customer1.id)
      invoice2 = Invoice.create(status: 1, customer_id: customer1.id)

      invoice3 = Invoice.create(status: 1, customer_id: customer1.id)
      invoice4 = Invoice.create(status: 1, customer_id: customer1.id)
      invoice5 = Invoice.create(status: 1, customer_id: customer1.id)
    
      invoice6 = Invoice.create(status: 2, customer_id: customer1.id)
      invoice7 = Invoice.create(status: 2, customer_id: customer1.id)

      @invoices = Invoice.all 

      expect(@invoices.not_complete).to eq([invoice1, invoice2, invoice3, invoice4, invoice5])
      
      end
    end
  end

  describe "#total_revenue" do
    it 'calculates the total revenue for invoice items ' do
      merchant1 = Merchant.create(name: "Spongebob", enabled: true)
      merchant2 = Merchant.create(name: "Plankton" , enabled: true)

      item1 = merchant1.items.create(name: "Krabby Patty", description: "yummy", unit_price: "999")
      item2 = merchant1.items.create(name: "Diet Dr Kelp", description: "spicy", unit_price: "555")

      customer1 = Customer.create(first_name: "Patrick", last_name: "Star")
      customer2 = Customer.create(first_name: "Sandy", last_name: "Cheeks")
      
      invoice1 = Invoice.create(status: 1, customer_id: customer1.id)
      invoice2 = Invoice.create(status: 1, customer_id: customer2.id)
      
      invoiceitem1 = InvoiceItem.create(quantity: 3, unit_price: 999, status: 1, invoice_id: invoice1.id, item_id: item1.id)
      invoiceitem2 = InvoiceItem.create(quantity: 2, unit_price: 555, status: 1, invoice_id: invoice2.id, item_id: item2.id)
      
      expect(invoice1.total_revenue).to eq(2997)
      expect(invoice2.total_revenue).to eq(1110)
    end
  end

  describe "#customer_name" do
    it 'will display the customers first and last name' do
      customer1 = Customer.create(first_name: "Patrick", last_name: "Star")
      customer2 = Customer.create(first_name: "Sandy", last_name: "Cheeks")

      invoice1 = Invoice.create(status: 1, customer_id: customer1.id)
      invoice2 = Invoice.create(status: 1, customer_id: customer2.id)
      
      expect(invoice1.customer_name).to eq( "Patrick Star")
      expect(invoice2.customer_name).to eq( "Sandy Cheeks")
    end
  end

  describe "#formatted_date" do
    it 'will display the created at date as Monday, December 01, 2021 format' do
      customer1 = Customer.create(first_name: "Patrick", last_name: "Star")
      customer2 = Customer.create(first_name: "Sandy", last_name: "Cheeks")

      invoice1 = Invoice.create(status: 1, customer_id: customer1.id)
      invoice2 = Invoice.create(status: 1, customer_id: customer2.id)
      
      specific_date = DateTime.new(2023, 11, 8)
      invoice1.update(created_at: specific_date)
      invoice2.update(created_at: specific_date)
      
      expect(invoice1.formatted_date).to eq("Wednesday, November 08, 2023")
      expect(invoice2.formatted_date).to eq("Wednesday, November 08, 2023")
    end
  end

  describe "discounted revenue" do
    it 'calculates the total discounted revenue for invoice items' do
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
      
      expect(invoice1.discounted_revenue).to eq(3023)
    end
  end
end