require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @regular_user = User.create!(name: "Harry Richard", address: "1234 Bland St.", city: "Denver", state: "CO", zip: "80085", email: "regular_user@email.com", password: "123", role: 0)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @order_1 = @regular_user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)

      @order_1.item_orders.create!(status: "pending", item: @tire, price: @tire.price, quantity: 2)
      @order_1.item_orders.create!(status: "pending", item: @pull_toy, price: @pull_toy.price, quantity: 3)

      # Testing block for total_item_count and total_item_value:
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @gator_tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 115, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @zebra_tire = @meg.items.create!(name: "Zebraskins", description: "They'll never pop!", price: 200, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      @user1 = User.create!(name: "Jim Bob", address: "2020 Whiskey River Blvd", city: "Bamaville", state: "AL", zip: "33675", email: "jimbobwoowoo@aol.com", password: "merica4lyfe", role: 1, merchant_id: @meg.id)
      @order3 = @user1.orders.create!(id: 3, name: "Jim", address: "2020 Whiskey River Blvd", city: "Bamaville", state: "AL", zip: 33675)
      @order3.item_orders.create!(order_id: @order3.id, item: @zebra_tire, quantity: 5, price: @zebra_tire.price, status: "pending")
    end

    it 'grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it "total_item_count" do
      expect(@order3.total_item_count(@meg.id)).to eq(5)
    end

    it "total_item_value" do
      expect(@order3.total_item_value(@meg.id)).to eq(1000)
    end
  end
end
