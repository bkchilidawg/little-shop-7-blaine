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
    xit 'will display the created at date as Monday, December 01, 2021 format' do
      customer1 = Customer.create(first_name: "Patrick", last_name: "Star")
      customer2 = Customer.create(first_name: "Sandy", last_name: "Cheeks")

      invoice1 = Invoice.create(status: 1, customer_id: customer1.id)
      invoice2 = Invoice.create(status: 1, customer_id: customer2.id)
      
      expect(invoice1.formatted_date).to eq("Wednesday, November 08, 2023")
      expect(invoice2.formatted_date).to eq("Wednesday, November 08, 2023")
    end
  end
end