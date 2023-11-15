require 'rails_helper' 

RSpec.describe "Admins Invoices Show", type: :feature do 
  before(:each) do 
    @merchant1 = Merchant.create(name: "Spongebob")
    @merchant2 = Merchant.create(name: "Plankton")

    @item1 = @merchant1.items.create(name: "Krabby Patty", description: "yummy", unit_price: "999")
    @item2 = @merchant1.items.create(name: "Diet Dr Kelp", description: "spicy", unit_price: "555")
    @item3 = @merchant1.items.create(name: "Pretty Pattie", description: "cute", unit_price: "333")
    @item4 = @merchant2.items.create(name: "Chum Bucket", description: "chummy", unit_price: "111")
    @item5 = @merchant1.items.create(name: "Pancakes", description: "fluffy", unit_price: "444")
    @item6 = @merchant1.items.create(name: "Crepes", description: "savory", unit_price: "888")
    @item7 = @merchant1.items.create(name: "Waffles", description: "thick", unit_price: "222")

    @customer1 = Customer.create(first_name: "Patrick", last_name: "Star")
    @customer2 = Customer.create(first_name: "Sandy", last_name: "Cheeks")
    @customer3 = Customer.create(first_name: "Misses", last_name: "Puff")

    @invoice1 = Invoice.create(status: 0, customer_id: @customer1.id)
    @invoice2 = Invoice.create(status: 1, customer_id: @customer2.id)
    @invoice3 = Invoice.create(status: 2, customer_id: @customer3.id)
    @invoice4 = Invoice.create(status: 1, customer_id: @customer3.id)


    @invoiceitem1 = InvoiceItem.create(quantity: 3, unit_price: 999, status: 1, invoice_id: @invoice1.id, item_id: @item1.id)
    @invoiceitem2 = InvoiceItem.create(quantity: 2, unit_price: 555, status: 1, invoice_id: @invoice2.id, item_id: @item2.id)
    @invoiceitem3 = InvoiceItem.create(quantity: 1, unit_price: 333, status: 1, invoice_id: @invoice1.id, item_id: @item3.id)
    @invoiceitem4 = InvoiceItem.create(quantity: 20, unit_price: 111, status: 1, invoice_id: @invoice3.id, item_id: @item4.id)
    @invoiceitem5 = InvoiceItem.create(quantity: 2, unit_price: 444, status: 1, invoice_id: @invoice3.id, item_id: @item5.id)
    @invoiceitem6 = InvoiceItem.create(quantity: 3, unit_price: 888, status: 1, invoice_id: @invoice4.id, item_id: @item6.id)
    @invoiceitem7 = InvoiceItem.create(quantity: 5, unit_price: 222, status: 1, invoice_id: @invoice4.id, item_id: @item7.id)

    @bulk_discount1 = @merchant1.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 20)
    @bulk_discount2 = @merchant1.bulk_discounts.create!(quantity_threshold: 20, percentage_discount: 30)
    
  end

  describe "US33. When I visit my admin's invoices show " do 
    it "then I see information related to that invoice" do
      visit "/admin/invoices/#{@invoice1.id}"
      expect(page).to have_content("#{@invoice1.id}")
      expect(page).to have_content("#{@invoice1.status}")
      expect(page).to have_content("#{@invoice1.created_at.strftime("%A, %B %d, %Y")}")
      expect(page).to have_content("#{@customer1.first_name}")
      expect(page).to have_content("#{@customer1.last_name}")

      visit "/admin/invoices/#{@invoice2.id}"
      expect(page).to have_content("#{@invoice2.id}")
      expect(page).to have_content("#{@invoice2.status}")
      expect(page).to have_content("#{@invoice2.created_at.strftime("%A, %B %d, %Y")}")
      expect(page).to have_content("#{@customer2.first_name}")
      expect(page).to have_content("#{@customer2.last_name}")

      visit "/admin/invoices/#{@invoice3.id}"
      expect(page).to have_content("#{@invoice3.id}")
      expect(page).to have_content("#{@invoice3.status}")
      expect(page).to have_content("#{@invoice3.created_at.strftime("%A, %B %d, %Y")}")
      expect(page).to have_content("#{@customer3.first_name}")
      expect(page).to have_content("#{@customer3.last_name}")
    end
  end 

  describe "US34. When I visit my admin's invoices show " do 
    it "then I see all the items on that invoice and their attributes" do
      visit "/admin/invoices/#{@invoice1.id}"
      
      expect(page).to have_content("#{@item1.name}")
      expect(page).to have_content("#{@invoiceitem1.quantity}")
      expect(page).to have_content("#{@item1.unit_price}")
      expect(page).to have_content("#{@invoiceitem1.status}")
      
      expect(page).to have_content("#{@item3.name}")
      expect(page).to have_content("#{@invoiceitem3.quantity}")
      expect(page).to have_content("#{@item3.unit_price}")
      expect(page).to have_content("#{@invoiceitem3.status}")

      visit "/admin/invoices/#{@invoice3.id}"

      expect(page).to have_content("#{@item4.name}")
      expect(page).to have_content("#{@invoiceitem4.quantity}")
      expect(page).to have_content("#{@item4.unit_price}")
      expect(page).to have_content("#{@invoiceitem4.status}")
      
    end
  end

  describe "US35. When I visit my admin invoice show page" do
    it "Then I see the total revenue that will be generated from all of my invoices" do
      visit "/admin/invoices/#{@invoice3.id}"

      expect(page).to have_content("Total Revenue: #{@total_revenue}")
      expect(page).to have_content("3108")

      visit "/admin/invoices/#{@invoice4.id}"

      expect(page).to have_content("Total Revenue: #{@total_revenue}")
      expect(page).to have_content("3774")
    end
  end

  describe "US36. When I visit my admin invoice show page" do
    it "I see that each invoice status is a select field 
    and I see that the invoice current status is selected" do
      visit "/admin/invoices/#{@invoice1.id}"
      expect(page).to have_select("Invoice Status:", :with_options => ["cancelled", "in progress", "completed"])
      expect(@invoice1.status).to eq("cancelled")

      visit "/admin/invoices/#{@invoice2.id}"
      expect(page).to have_select("Invoice Status:", :with_options => ["cancelled", "in progress", "completed"])
      expect(@invoice2.status).to eq("in progress")

      visit "/admin/invoices/#{@invoice3.id}"
      expect(page).to have_select("Invoice Status:", :with_options => ["cancelled", "in progress", "completed"])
      expect(@invoice3.status).to eq("completed")

      visit "/admin/invoices/#{@invoice4.id}"
      expect(page).to have_select("Invoice Status:", :with_options => ["cancelled", "in progress", "completed"])
      expect(@invoice4.status).to eq("in progress")
    end

    it "I can select a new status for the invoice, select Update Invoice Status, 
      get taken back to admin invoice show page and see status has been updated" do
      visit "/admin/invoices/#{@invoice1.id}"
      expect(page).to have_button("Update Invoice Status")
    
      select 'in progress', from: 'Invoice Status:'
      click_button 'Update Invoice Status'

      expect(current_path).to eq("/admin/invoices/#{@invoice1.id}")
      expect(page).to have_select('Invoice Status:', selected: 'in progress')
      
      visit "/admin/invoices/#{@invoice2.id}"
      expect(page).to have_button("Update Invoice Status")

      select 'completed', from: 'Invoice Status:'
      click_button 'Update Invoice Status'

      expect(current_path).to eq("/admin/invoices/#{@invoice2.id}")
      expect(page).to have_select('Invoice Status:', selected: 'completed')

      visit "/admin/invoices/#{@invoice3.id}"
      expect(page).to have_button("Update Invoice Status")

      select 'cancelled', from: 'Invoice Status:'
      click_button 'Update Invoice Status'

      expect(current_path).to eq("/admin/invoices/#{@invoice3.id}")
      expect(page).to have_select('Invoice Status:', selected: 'cancelled')

      visit "/admin/invoices/#{@invoice4.id}"
      expect(page).to have_button("Update Invoice Status")

      select 'in progress', from: 'Invoice Status:'
      click_button 'Update Invoice Status'

      expect(current_path).to eq("/admin/invoices/#{@invoice4.id}")
      expect(page).to have_select('Invoice Status:', selected: 'in progress')
    end
  end

  describe "When I visit an admin invoice show page" do
    it "Then I see the total revenue from this invoice (not including discounts)" do
      visit "/admin/invoices/#{@invoice1.id}"

      expect(page).to have_content("Total Revenue: 3330")
    end

    it "And I see the total discounted revenue from this invoice which includes bulk discounts in the calculation" do
      visit "/admin/invoices/#{@invoice3.id}"
      
      expect(page).to have_content("Total Discounted Revenue: 3108")
    end
  end
  
end