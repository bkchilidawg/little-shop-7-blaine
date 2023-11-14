require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Show' do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Merchant 1")
    @discount1 = @merchant1.bulk_discounts.create!(percentage_discount: 10, quantity_threshold: 10)
    @discount2 = @merchant1.bulk_discounts.create!(percentage_discount: 15, quantity_threshold: 15)
  end

  describe 'when I visit my bulk discount show page' do
    it 'shows the bulk discount quantity threshold and percentage discount' do
      visit merchant_bulk_discount_path(@merchant1, @discount1)
      
      expect(page).to have_content(@discount1.quantity_threshold)
      expect(page).to have_content(@discount1.percentage_discount)
    end
  end
end