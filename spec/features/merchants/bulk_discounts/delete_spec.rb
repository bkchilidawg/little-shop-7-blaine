require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Delete' do
  describe 'when a merchant visits the bulk discounts index page' do
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
      visit merchant_bulk_discounts_path(@merchant1)
    end

    it 'displays a delete button next to each bulk discount' do
      expect(page).to have_link('Delete')
    end

    describe 'when the merchant clicks the delete button' do
      before(:each) do
        within("#bulk-discount-#{@bulk_discount2.id}") do
          click_link 'Delete'
        end
      end

      it 'redirects back to the bulk discounts index page' do
        expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
      end

      it 'no longer displays the deleted discount' do
        
        expect(page).to_not have_content(@bulk_discount2.percentage_discount)
        expect(page).to_not have_content(@bulk_discount2.quantity_threshold)
      end
    end

    describe 'when I click the delete link, but the bulk discount has a pending invoice' do
      it 'does not allow the merchant to delete the bulk discount' do
        
        
        within("#bulk-discount-#{@bulk_discount1.id}") do
          click_link 'Delete'
        end

        expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
        expect(page).to have_content('25')
        expect(page).to have_content('15')
        expect(page).to have_content('30')
        expect(page).to have_content('20')
      end
    end
  end
end