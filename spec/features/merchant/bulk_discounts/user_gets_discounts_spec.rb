require 'rails_helper'

RSpec.describe "As a customer" do
  before :each do
    @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @mike = Merchant.create!(name: "Bakery", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pencil = @meg.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    @bread = @mike.items.create(name: "French Bread", description: "Just perfect!", price: 4, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 50)
    
    @employee_user_1 = User.create!(name: "Mary Jane", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "employee_user@email.com", password: "123", role: 1, merchant_id: @meg.id)
    @employee_user_2 = User.create!(name: "Mike Jones", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "employee_user_2@email.com", password: "123", role: 1, merchant_id: @mike.id)
    @regular_user = User.create!(name: "Harry Richard", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "regular_user@email.com", password: "123", role: 0)

    visit '/'

    within ".topnav" do
      click_link("Login")
    end
    
    fill_in :email, with: @employee_user_1.email
    fill_in :password, with: @employee_user_1.password
    click_on "Submit"
    click_link("Merchant Dashboard")
    expect(current_path).to eq("/merchant")
    
    click_link "Set My Discounts"
    
    expect(current_path).to eq("/merchant/bulk_discounts")
    
    #1st Discount
    click_link "Create New Discount"
    
    expect(BulkDiscount.last).to eq(nil)
    
    
    fill_in :title, with: "Labor Day Sale!"
    fill_in :minimum_item_quantity, with: "2"
    fill_in :percent_discount, with: "25"
    
    click_on "Create This Discount"
    expect(BulkDiscount.last).to_not eq(nil)
    expect(current_path).to eq("/merchant")
    
    #2nd Discount
    click_link "Set My Discounts"
    
    expect(current_path).to eq("/merchant/bulk_discounts")
    
    click_link "Create New Discount"
    
    fill_in :title, with: "Anniversary Sale!"
    fill_in :minimum_item_quantity, with: "3"
    fill_in :percent_discount, with: "50"
    
    click_on "Create This Discount"
    
    
    #3rd Discount
    click_link "Set My Discounts"
    
    click_link "Create New Discount"
    
    fill_in :title, with: "Blowout Sale!"
    fill_in :minimum_item_quantity, with: "5"
    fill_in :percent_discount, with: "99"
    
    click_on "Create This Discount"
    
    within ".topnav" do
      click_link("Logout")
    end
    
    visit '/'

    within ".topnav" do
      click_link("Login")
    end
    
    fill_in :email, with: @employee_user_2.email
    fill_in :password, with: @employee_user_2.password
    click_on "Submit"
    click_link("Merchant Dashboard")
    expect(current_path).to eq("/merchant")
    
    click_link "Set My Discounts"
    
    expect(current_path).to eq("/merchant/bulk_discounts")
    
    #4th Discount
    click_link "Create New Discount"
    
    fill_in :title, with: "Mike's Bakery Opening!"
    fill_in :minimum_item_quantity, with: "5"
    fill_in :percent_discount, with: "25"
    
    click_on "Create This Discount"
    expect(BulkDiscount.last).to_not eq(nil)
    
    expect(current_path).to eq("/merchant")
    
    within ".topnav" do
      click_link("Logout")
    end
    
    within ".topnav" do
      click_link("Login")
    end
    
    fill_in :email, with: @regular_user.email
    fill_in :password, with: @regular_user.password
    click_on "Submit"
    
    visit "/items/#{@tire.id}"
    click_on "Add To Cart"
    visit "/items/#{@bread.id}"
    click_on "Add To Cart"
    visit "/items/#{@bread.id}"
    click_on "Add To Cart"
    visit "/items/#{@bread.id}"
    click_on "Add To Cart"
    visit "/items/#{@bread.id}"
    click_on "Add To Cart"

  end
  
  it "I see a merchant's available discounts on their items index page" do
    
    visit "/merchants/#{@meg.id}/items"

    expect(page).to have_content("Labor Day Sale! 25% off a group of like items when you purchase 2 or more!")
  end

  it "I can add items to my cart, then checkout and have the discounts applied" do
    
    visit "/cart"
    
    within("#item_subtotal-#{@tire.id}") do
      expect(page).to_not have_content('Discount Applied!')
    end
    
    #1st Discount
    within("#item_quantity-#{@tire.id}") do
      click_on "+"
    end
    
    within("#item_subtotal-#{@tire.id}") do
      expect(page).to have_content('"Labor Day Sale!" Discount Applied!')
    end
    
    within("#item_subtotal-#{@bread.id}") do
      expect(page).to_not have_content('"Labor Day Sale!" Discount Applied!')
    end
    
    #2nd Discount
    within("#item_quantity-#{@tire.id}") do
      click_on "+"
    end
    
    within("#item_subtotal-#{@tire.id}") do
      expect(page).to have_content('"Anniversary Sale!" Discount Applied!')
    end
    
    within("#item_subtotal-#{@bread.id}") do
      expect(page).to_not have_content('"Anniversary Sale" Discount Applied!')
    end
    
    # 3rd Discount
    within("#item_quantity-#{@tire.id}") do
      click_on "+"
      click_on "+"
    end
    
    within("#item_subtotal-#{@tire.id}") do
      expect(page).to have_content('"Blowout Sale!')
    end
    
    within("#item_subtotal-#{@bread.id}") do
      expect(page).to_not have_content('"Blowout Sale!')
    end
    
    expect(page).to have_content("Total: $21.00")
    
    # 4th Discount
    
    within("#item_subtotal-#{@bread.id}") do
      expect(page).to_not have_content("Mike's Bakery Opening!")
    end
    
    within("#item_quantity-#{@bread.id}") do
      click_on "+"
      click_on "+"
    end

    within("#item_subtotal-#{@bread.id}") do
      expect(page).to have_content("Mike's Bakery Opening!")
    end

    expect(page).to have_content("Total: $23.00")
    
    within("#item_quantity-#{@bread.id}") do
      click_on "-"
      click_on "-"
    end
    
    within("#item_subtotal-#{@bread.id}") do
      expect(page).to_not have_content("Mike's Bakery Opening!")
    end
    
    within("#item_quantity-#{@tire.id}") do
      click_on "-"
      click_on "-"
      click_on "-"
      click_on "-"
    end
    
    within("#item_subtotal-#{@tire.id}") do
      expect(page).to_not have_content('"Blowout Sale!')
    end

    expect(page).to have_content("Total: $116.00")
  end
  
  it "After viewing my cart, and I see discounts applied above the new order form" do
    
    visit "/cart"
    
    within("#item_subtotal-#{@tire.id}") do
      expect(page).to_not have_content('Discount Applied!')
    end
    
    within("#item_quantity-#{@tire.id}") do
      click_on "+"
    end
    
    within("#item_subtotal-#{@tire.id}") do
      expect(page).to have_content('"Labor Day Sale!" Discount Applied!')
    end
    
    click_link "Checkout"
    
    within("#order-item-#{@tire.id}") do
      expect(page).to have_content('"Labor Day Sale!" Discount Applied!')
    end
    within("#order-item-#{@bread.id}") do
      expect(page).to_not have_content('"Labor Day Sale!" Discount Applied!')
    end
    
    expect(page).to have_content("Total: $166")
    
  end
  
  it "On the new orders page, I click create order and i see my discounted grand total on my orders page"do
    
    visit "/cart"
    
    within("#item_quantity-#{@tire.id}") do
      click_on "+"
    end
    
    click_on "Checkout"
    
    expect(current_path).to eq("/orders/new")
    
    expect(page).to have_content("Total: $166")
    
    fill_in :name, with: "Garrett Gerdsen"
    fill_in :address, with: "2 Real Rd."
    fill_in :city, with: "Denver"
    fill_in :state, with: "CO"
    fill_in :zip, with: "12345"
    
    click_on "Create Order"
    
    expect(current_path).to eq("/profile/orders")
    
    expect(page).to have_content("Grand Total of Order: $166.00")
    
    order = Order.last
    
    visit "/orders/#{order.id}"
    
    expect(page).to have_content("Total: $166.00")
    
  end
end