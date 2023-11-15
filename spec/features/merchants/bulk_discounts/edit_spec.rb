require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Edit' do
  before(:each) do
    @merchant1 = Merchant.create(name: "Spongebob")
    @discount1 = @merchant1.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 20)
    @item1 = @merchant1.items.create!(name: "Item 1", description: "Description", unit_price: 10)
    @customer1 = Customer.create!(first_name: "Customer", last_name: "Test")
    @invoice1 = @customer1.invoices.create!(status: 0) 
    @invoice2 = @customer1.invoices.create!(status: 1) 
    @invoice_item1 = InvoiceItem.create!(item: @item1, invoice: @invoice1, quantity: 10, unit_price: 10, status: 0) 
    @invoice_item2 = InvoiceItem.create!(item: @item1, invoice: @invoice2, quantity: 10, unit_price: 10, status: 1) 
  end

  describe 'when I visit my bulk discount show page' do
    it 'shows a link to edit the bulk discount' do

      visit merchant_bulk_discount_path(@merchant1, @discount1)

      expect(page).to have_link('Edit Bulk Discount')
    end

    describe 'when I click the edit link' do
      before(:each) do
        visit merchant_bulk_discount_path(@merchant1, @discount1)
       
        click_link 'Edit Bulk Discount'
      end

      it 'takes me to a new page with a form to edit the discount' do

        expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @discount1))

        expect(page).to have_selector('form')
      end

      it 'pre-populates the form with the discount attributes' do
        expect(find_field('bulk_discount[percentage_discount]').value).to eq(@discount1.percentage_discount.to_s)

        expect(find_field('bulk_discount[quantity_threshold]').value).to eq(@discount1.quantity_threshold.to_s)
      end

      describe 'when I change the information and click submit' do
        before(:each) do
          fill_in 'bulk_discount[percentage_discount]', with: 20
          fill_in 'bulk_discount[quantity_threshold]', with: 10

          click_button 'Update Bulk Discount'
        end

        it 'redirects me to the bulk discount show page' do

          expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @discount1))
        end

        it 'shows that the discount attributes have been updated' do
          
          expect(page).to have_content('20')
          expect(page).to have_content('10')
        end
      end

      
      describe 'with invalid parameters' do
        it 'does not update the bulk discount' do

          fill_in 'bulk_discount[percentage_discount]', with: -20
          fill_in 'bulk_discount[quantity_threshold]', with: -10

          click_button 'Update Bulk Discount'
          
          expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @discount1))
          expect(page).not_to have_content(-10)
          expect(page).not_to have_content(-20)
          expect(page).to have_content(10)
          expect(page).to have_content(20)
        end
      end
      describe 'when I click the edit link, but has a pending invoice' do
        it 'does not allow the merchant to edit a bulk discount' do
  
          visit merchant_bulk_discount_path(@merchant1, @discount1)
       
          click_link 'Edit Bulk Discount'

          fill_in 'bulk_discount[percentage_discount]', with: 25
          fill_in 'bulk_discount[quantity_threshold]', with: 15

          click_button 'Update Bulk Discount'
          
          expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @discount1))
          expect(page).to have_content('20')
          expect(page).to have_content('10')
        end
      end
    end
  end
end
