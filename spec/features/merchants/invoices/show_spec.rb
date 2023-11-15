require 'rails_helper' 

RSpec.describe "Merchants Invoices Show", type: :feature do 
  before(:each) do 
    @merchant1 = Merchant.create(name: "Spongebob")
    @merchant2 = Merchant.create(name: "Plankton")

    @item1 = @merchant1.items.create(name: "Krabby Patty", description: "yummy", unit_price: "999")
    @item2 = @merchant1.items.create(name: "Diet Dr Kelp", description: "spicy", unit_price: "555")
    @item3 = @merchant1.items.create(name: "Pretty Pattie", description: "cute", unit_price: "333")
    @item4 = @merchant1.items.create(name: "Chum Bucket", description: "chummy", unit_price: "111")
    @item5 = @merchant1.items.create(name: "Pancakes", description: "fluffy", unit_price: "444")
    @item6 = @merchant1.items.create(name: "Crepes", description: "savory", unit_price: "888")
    @item7 = @merchant1.items.create(name: "Waffles", description: "thick", unit_price: "222")

    @customer1 = Customer.create(first_name: "Patrick", last_name: "Star")
    @customer2 = Customer.create(first_name: "Sandy", last_name: "Cheeks")
    @customer3 = Customer.create(first_name: "Misses", last_name: "Puff")

    @invoice1 = Invoice.create(status: 1, customer_id: @customer1.id)
    @invoice2 = Invoice.create(status: 1, customer_id: @customer2.id)
    @invoice3 = Invoice.create(status: 1, customer_id: @customer3.id)
    @invoice4 = Invoice.create(status: 1, customer_id: @customer3.id)


    @invoiceitem1 = InvoiceItem.create(quantity: 3, unit_price: 999, status: 1, invoice_id: @invoice1.id, item_id: @item1.id)
    @invoiceitem2 = InvoiceItem.create(quantity: 2, unit_price: 555, status: 1, invoice_id: @invoice2.id, item_id: @item2.id)
    @invoiceitem3 = InvoiceItem.create(quantity: 1, unit_price: 333, status: 1, invoice_id: @invoice1.id, item_id: @item3.id)
    @invoiceitem4 = InvoiceItem.create(quantity: 20, unit_price: 111, status: 1, invoice_id: @invoice3.id, item_id: @item4.id)
    @invoiceitem5 = InvoiceItem.create(quantity: 2, unit_price: 444, status: 0, invoice_id: @invoice3.id, item_id: @item5.id)
    @invoiceitem6 = InvoiceItem.create(quantity: 3, unit_price: 888, status: 0, invoice_id: @invoice4.id, item_id: @item6.id)
    @invoiceitem7 = InvoiceItem.create(quantity: 5, unit_price: 222, status: 1, invoice_id: @invoice4.id, item_id: @item7.id)

    @bulk_discount1 = @merchant1.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 20)
    @bulk_discount2 = @merchant1.bulk_discounts.create!(quantity_threshold: 20, percentage_discount: 30)
 end

  describe "US15. When I visit my merchant's invoices show " do 
    it "then I see information related to that invoice" do
      visit "/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}"
      expect(page).to have_content("#{@invoice1.id}")
      expect(page).to have_content("#{@invoice1.status}")
      expect(page).to have_content("#{@invoice1.created_at.strftime("%A, %B %d, %Y")}")
      expect(page).to have_content("#{@customer1.first_name}")
      expect(page).to have_content("#{@customer1.last_name}")

      visit "/merchants/#{@merchant1.id}/invoices/#{@invoice2.id}"
      expect(page).to have_content("#{@invoice2.id}")
      expect(page).to have_content("#{@invoice2.status}")
      expect(page).to have_content("#{@invoice2.created_at.strftime("%A, %B %d, %Y")}")
      expect(page).to have_content("#{@customer2.first_name}")
      expect(page).to have_content("#{@customer2.last_name}")
    end
  end 

  describe "US16. When I visit my merchant's invoices show " do 
    it "then I see all the items on that invoice and their attributes" do
      visit "/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}"
      
      # require 'pry'; binding.pry
      expect(page).to have_content("#{@item1.name}")
      expect(page).to have_content("#{@invoiceitem1.quantity}")
      expect(page).to have_content("#{@item1.unit_price}")
      expect(page).to have_content("#{@invoiceitem1.status}")
      
      expect(page).to have_content("#{@item3.name}")
      expect(page).to have_content("#{@invoiceitem3.quantity}")
      expect(page).to have_content("#{@item3.unit_price}")
      expect(page).to have_content("#{@invoiceitem3.status}")

    end
  end

  describe "US17. When I visit my merchant invoice show page" do
    it "Then I see the total revenue that will be generated from all of my items on the invoice" do
      visit "/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}"

      expect(page).to have_content("Total Revenue: #{@total_revenue}")
      expect(page).to have_content("3330")

      visit "/merchants/#{@merchant1.id}/invoices/#{@invoice2.id}"

      expect(page).to have_content("Total Revenue: #{@total_revenue}")
      expect(page).to have_content("1110")

      visit "/merchants/#{@merchant1.id}/invoices/#{@invoice3.id}"

      expect(page).to have_content("Total Revenue: #{@total_revenue}")
      expect(page).to have_content("444")
    end
    
  end

  describe "US18. When I visit my merchant invoice show page" do
    it "I see that each invoice item status is a select field 
    and I see that the invoice item's current status is selected" do
      visit "/merchants/#{@merchant1.id}/invoices/#{@invoice3.id}"
  
      expect(page).to have_select("Status:", :with_options => ["packaged", "pending", "shipped"])
      expect(@invoiceitem4.status).to eq("pending")
      expect(@invoiceitem5.status).to eq("packaged")

      visit "/merchants/#{@merchant1.id}/invoices/#{@invoice4.id}"
      expect(page).to have_select("Status:", :with_options => ["packaged", "pending", "shipped"])
      expect(@invoiceitem6.status).to eq("packaged")
      expect(@invoiceitem7.status).to eq("pending")
    end

    it "I can select a new status for the Item, select Update Item Status, 
      get taken back to merchant invoice show page and see status has been updated" do
      visit "/merchants/#{@merchant1.id}/invoices/#{@invoice3.id}"

      expect(page).to have_button("Update Item Status")
      
      within("#invoiceitem#{@invoiceitem4.id}") do
        select 'shipped', from: 'Status:'
        click_button 'Update Item Status'
        expect(current_path).to eq("/merchants/#{@merchant1.id}/invoices/#{@invoice3.id}")
        expect(page).to have_select('Status:', selected: 'shipped')
      end
      
      within("#invoiceitem#{@invoiceitem5.id}") do
        select 'pending', from: 'Status:'
        click_button 'Update Item Status'
        expect(current_path).to eq("/merchants/#{@merchant1.id}/invoices/#{@invoice3.id}")
        expect(page).to have_select('Status:', selected: 'pending')
      end

      visit "/merchants/#{@merchant1.id}/invoices/#{@invoice4.id}"

      expect(page).to have_button("Update Item Status")

      within("#invoiceitem#{@invoiceitem6.id}") do
        select 'pending', from: 'Status:'
        click_button 'Update Item Status'
        expect(current_path).to eq("/merchants/#{@merchant1.id}/invoices/#{@invoice4.id}")
        expect(page).to have_select('Status:', selected: 'pending')
      end

      within("#invoiceitem#{@invoiceitem7.id}") do
        select 'shipped', from: 'Status:'
        click_button 'Update Item Status'
        expect(current_path).to eq("/merchants/#{@merchant1.id}/invoices/#{@invoice4.id}")
        expect(page).to have_select('Status:', selected: 'shipped')
      end
    end

    describe " When I visit my merchant invoice show page" do
      it "displays the total revenue for the merchant from this invoice (not including discounts)" do
        visit "/merchants/#{@merchant1.id}/invoices/#{@invoice3.id}"

        expect(page).to have_content("Total Revenue: #{@total_revenue}")
        expect(page).to have_content("3108") 
      end

      it "displays the total discounted revenue for the merchant from this invoice which includes bulk discounts in the calculation" do
        visit "/merchants/#{@merchant1.id}/invoices/#{@invoice3.id}"

        expect(page).to have_content("Total Discounted Revenue: #{@total_discounted_revenue}")
        expect(page).to have_content("2442") 
      end
    end

    describe "When I visit my merchant invoice show page" do
      it "displays a link to the bulk discount applied to the invoice item" do
        visit "/merchants/#{@merchant1.id}/invoices/#{@invoice3.id}"

        expect(page).to have_content("Applied Bulk Discount:")
        expect(page).to have_link("View Discount")
      end
    end

  end
end