require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Index' do
  describe 'As a merchant' do
    before(:each) do
      @merchant1 = Merchant.create!(name: "Merchant 1")
      @discount1 = @merchant1.bulk_discounts.create!(percentage_discount: 10, quantity_threshold: 10, merchant: @merchant1)
      @discount2 = @merchant1.bulk_discounts.create!(percentage_discount: 15, quantity_threshold: 15, merchant: @merchant1)
    end

    it 'displays a link to view all bulk discounts' do
      visit merchant_dashboard_path(@merchant1)

      expect(page).to have_link('View All Bulk Discounts')
    end

    it 'displays all bulk discounts with percentage discount and quantity thresholds' do
      visit merchant_dashboard_path(@merchant1)

      click_link 'View All Bulk Discounts'

      expect(page).to have_content(@discount1.percentage_discount)
      expect(page).to have_content(@discount1.quantity_threshold)
      expect(page).to have_content(@discount2.percentage_discount)
      expect(page).to have_content(@discount2.quantity_threshold)
    end

    it 'displays a link to the show page for each bulk discount' do
      visit merchant_dashboard_path(@merchant1)

      click_link 'View All Bulk Discounts'

      expect(page).to have_link('View Bulk Discount', count: 2)
    end

    it 'displays a link to create a new bulk discount' do
      visit merchant_dashboard_path(@merchant1)

      click_link 'View All Bulk Discounts'

      expect(page).to have_link('Create New Bulk Discount')
    end

    it 'creates a new bulk discount when valid data is submitted' do
      visit merchant_dashboard_path(@merchant1)

      click_link 'View All Bulk Discounts'

      click_link 'Create New Bulk Discount'

      fill_in 'bulk_discount[percentage_discount]', with: 20
      fill_in 'bulk_discount[quantity_threshold]', with: 20
      click_button 'Create Bulk Discount'

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
      expect(page).to have_content('20')
      expect(page).to have_content('20')
    end

    it 'displays a link to delete each bulk discount' do
      visit merchant_dashboard_path(@merchant1)

      click_link 'View All Bulk Discounts'

      expect(page).to have_link('Delete', count: 2)
    end

    it 'deletes a bulk discount when the delete button is clicked' do
      visit merchant_dashboard_path(@merchant1)

      click_link 'View All Bulk Discounts'

      expect(page).to have_content(@discount1.percentage_discount)
      expect(page).to have_content(@discount1.quantity_threshold)
      expect(page).to have_content(@discount2.percentage_discount)
      expect(page).to have_content(@discount2.quantity_threshold)

      within "#bulk-discount-#{@discount1.id}" do
        click_link 'Delete'
      end
    end
  end
end
