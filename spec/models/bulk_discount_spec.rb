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
    before(:each) do
      @merchant1 = Merchant.create(name: "Spongebob")
      @bulk_discount1 = @merchant1.bulk_discounts.create!(quantity_threshold: 15, percentage_discount: 25)
      @bulk_discount2 = @merchant1.bulk_discounts.create!(quantity_threshold: 20, percentage_discount: 30)
      @item1 = @merchant1.items.create!(name: "Item 1", description: "Description", unit_price: 10)
      @customer1 = Customer.create!(first_name: "Customer", last_name: "Test")
      @invoice1 = @customer1.invoices.create!(status: 1) 
      @invoice2 = @customer1.invoices.create!(status: 0) 
      @invoice_item1 = InvoiceItem.create!(item: @item1, invoice: @invoice1, quantity: 16, unit_price: 10, status: 1) 
      @invoice_item2 = InvoiceItem.create!(item: @item1, invoice: @invoice2, quantity: 20, unit_price: 10, status: 0) 
    end
    describe "#has_pending_invoice_items?" do
      it "returns true if there are pending invoice items that meet the quantity threshold" do
        

        expect(@bulk_discount1.has_pending_invoice_items?).to eq(true)
      end

      it "returns false if there are no pending invoice items that meet the quantity threshold" do
        

        expect(@bulk_discount2.has_pending_invoice_items?).to eq(false)
      end
    end
  end

  
end