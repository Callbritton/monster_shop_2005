require 'rails_helper'

RSpec.describe "As a merchant employee" do
  before :each do
    @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    @employee_user = User.create!(name: "Mary Jane", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "regular_user@email.com", password: "123", role: 1, merchant_id: @meg.id)

    visit '/'
    
    within ".topnav" do
      click_link("Login")
    end
    
    fill_in :email, with: @employee_user.email
    fill_in :password, with: @employee_user.password
    click_on "Submit"
    click_link("Merchant Dashboard")
    expect(current_path).to eq("/merchant")

  end
  
  it "I see a link to set my discounts, when I click this link I can define the discount and submit it in a form" do
  
    click_link "Set My Discounts"
    
    expect(current_path).to eq("/merchant/bulk_discounts")
    
    click_link "Create New Discount"
    
    expect(BulkDiscount.last).to eq(nil)
    
    fill_in :title, with: "Labor Day Sale!"
    fill_in :minimum_item_quantity, with: "5"
    fill_in :percent_discount, with: "25"
    
    click_on "Create This Discount"
    
    expect(current_path).to eq("/merchant")
    expect(page).to have_content("Discount Saved: Labor Day Sale! 25% off of a group of like items when you purchase 5 or more!")
    expect(BulkDiscount.last).to_not eq(nil)
    
    visit "/merchants/#{@meg.id}/items"

    expect(page).to have_content("Labor Day Sale! 25% off a group of like items when you purchase 5 or more!")
  end
end