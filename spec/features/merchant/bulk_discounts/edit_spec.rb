require 'rails_helper'

RSpec.describe "As a merchant employee" do
  before :each do
    @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    @employee_user = User.create!(name: "Mary Jane", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "employee_user@email.com", password: "123", role: 1, merchant_id: @meg.id)
    @regular_user = User.create!(name: "Harry Richard", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "regular_user@email.com", password: "123", role: 0)

    visit '/'
    
    within ".topnav" do
      click_link("Login")
    end
    
    fill_in :email, with: @employee_user.email
    fill_in :password, with: @employee_user.password
    click_on "Submit"
    click_link("Merchant Dashboard")
    expect(current_path).to eq("/merchant")
    
    click_link "Set My Discounts"
    
    expect(current_path).to eq("/merchant/bulk_discounts")
    
    click_link "Create New Discount"
    
    expect(BulkDiscount.last).to eq(nil)
    
    fill_in :title, with: "Labor Day Sale!"
    fill_in :minimum_item_quantity, with: "5"
    fill_in :percent_discount, with: "25"
    
    click_on "Create This Discount"
    expect(BulkDiscount.last).to_not eq(nil)
    expect(current_path).to eq("/merchant")

  end
  
  it "I see a link to edit discounts on a merchant's bulk discount index" do
    
    click_link "Set My Discounts"
    
    expect(current_path).to eq("/merchant/bulk_discounts")
    
    expect(page).to have_content(BulkDiscount.last.title)
    expect(BulkDiscount.last.title).to eq("Labor Day Sale!")
    expect(BulkDiscount.last.minimum_item_quantity).to eq(5)
    expect(BulkDiscount.last.percent_discount).to eq(25.0)
    
    click_link "Edit Discount"
    
    expect(current_path).to eq("/merchant/bulk_discounts/#{BulkDiscount.last.id}/edit")
    
    fill_in :title, with: "Edited Title!"
    fill_in :minimum_item_quantity, with: "1"
    fill_in :percent_discount, with: "1"
    
    click_on "Submit Changes For This Discount"
    
    expect(current_path).to eq("/merchant")
    expect(page).to have_content("Discount Updated: Edited Title! 1% off of a group of like items when you purchase 1 or more!")
    expect(page).to have_content(BulkDiscount.last.title)
    expect(BulkDiscount.last.title).to eq("Edited Title!")
    expect(BulkDiscount.last.minimum_item_quantity).to eq(1)
    expect(BulkDiscount.last.percent_discount).to eq(1.0)
    
    
    visit "/merchants/#{@meg.id}/items"

    expect(page).to have_content("Edited Title! 1% off a group of like items when you purchase 1 or more!")

    within ".topnav" do
      click_link("Logout")
    end

    within ".topnav" do
      click_link("Login")
    end
    
    fill_in :email, with: @regular_user.email
    fill_in :password, with: @regular_user.password
    click_on "Submit"

    visit "/merchants/#{@meg.id}/items"
    expect(page).to have_content("Edited Title! 1% off a group of like items when you purchase 1 or more!")
  
  end
end