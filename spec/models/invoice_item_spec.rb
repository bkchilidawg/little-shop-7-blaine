require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end

  before(:each) do 
    @merchant1 = Merchant.create!(name: "Spongebob")

    @customer1 = Customer.create!(first_name: "Sandy", last_name: "Cheeks")
    @customer2 = Customer.create!(first_name: "Mermaid", last_name: "Man")
    @customer3 = Customer.create!(first_name: "Sandy", last_name: "Cheeks")

    @item1 = Item.create!(name: "Krabby Patty", description: "Yummy", unit_price: 10, merchant_id: @merchant1.id)
    @item2 = Item.create!(name: "Chum Burger", description: "Not As Yummy", unit_price: 9, merchant_id: @merchant1.id)
    @item3 = Item.create!(name: "Krabby Patty with Jelly", description: "Damn Good", unit_price: 12, merchant_id: @merchant1.id)

    @invoice1 = Invoice.create!(status: 1, customer_id: @customer1.id)
    @invoice2 = Invoice.create!(status: 1, customer_id: @customer2.id)
    @invoice3 = Invoice.create!(status: 1, customer_id: @customer3.id)

    @invoice_item1 = InvoiceItem.create!(quantity: 4, unit_price: 40, status: 1, invoice_id: @invoice1.id, item_id: @item1.id)
    @invoice_item2 = InvoiceItem.create!(quantity: 7, unit_price: 36, status: 1, invoice_id: @invoice2.id, item_id: @item2.id)
    @invoice_item3 = InvoiceItem.create!(quantity: 15, unit_price: 48, status: 1, invoice_id: @invoice3.id, item_id: @item3.id)
    @invoice_item4 = InvoiceItem.create!(quantity: 1, unit_price: 48, status: 1, invoice_id: @invoice3.id, item_id: @item3.id)

    @bulk_discount1 = BulkDiscount.create!(percentage_discount: 10, quantity_threshold: 3, merchant_id: @merchant1.id)
    @bulk_discount2 = BulkDiscount.create!(percentage_discount: 20, quantity_threshold: 5, merchant_id: @merchant1.id)
    @bulk_discount3 = BulkDiscount.create!(percentage_discount: 30, quantity_threshold: 10, merchant_id: @merchant1.id)
  end

  describe "#instance_methods" do
    describe "item_name" do
      it "shows the name of the item that is associated with this specific invoice_item" do
        expect(@invoice_item1.item_name).to eq("Krabby Patty")
      end
    end  

    describe "applied_discount" do
      it "returns the highest percentage discount that applies to the quantity of the item" do
        
        expect(@invoice_item1.applied_discount).to eq(@bulk_discount1)
        expect(@invoice_item2.applied_discount).to eq(@bulk_discount2)
        expect(@invoice_item3.applied_discount).to eq(@bulk_discount3)
        expect(@invoice_item4.applied_discount).to eq(nil)
      end
    end

    describe "discounted_revenue" do
        it "calculates the discounted revenue for the invoice item" do

          expect(@invoice_item1.discounted_revenue).to eq(144)
          expect(@invoice_item2.discounted_revenue).to eq(201)
          expect(@invoice_item3.discounted_revenue).to eq(503)
          expect(@invoice_item4.discounted_revenue).to eq(48)
        end
      end
  end
end