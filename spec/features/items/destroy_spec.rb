require 'rails_helper'

RSpec.describe 'item delete', type: :feature do
  describe 'when I visit an item show page' do
    it 'I can delete an item' do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      chain = bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      visit "/items/#{chain.id}"

      expect(page).to have_link("Delete Item")

      click_on "Delete Item"

      expect(current_path).to eq("/items")
      expect("item-#{chain.id}").to be_present
    end

    it 'I can delete items and it deletes reviews' do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      chain = bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      review_1 = chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)

      visit "/items/#{chain.id}"

      click_on "Delete Item"
      expect(Review.where(id:review_1.id)).to be_empty
    end

    it 'I can not delete items with orders' do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      regular_user = User.create!(name: "Harry Richard", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "regular_user@email.com", password: "123", role: 0)
      chain = bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      review_1 = chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      order_1 = regular_user.orders.create!(name: 'Meg', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80218)
      order_1.item_orders.create!(item: chain, price: chain.price, quantity: 2, status: "pending")

      visit "/items/#{chain.id}"

      expect(page).to_not have_link("Delete Item")
    end
  end
end
