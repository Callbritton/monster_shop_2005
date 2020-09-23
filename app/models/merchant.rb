class Merchant <ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  has_many :users
  has_many :bulk_discounts

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip

  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(:order).pluck(:city)
  end

  def pending_orders
    Order.joins(:items).where(items: {merchant_id: id}).where(status: "pending").distinct
  end

  def disabled?
    self.disabled
  end

  def deactivate_items
    items.each do |item|
      item.update(active?: false)
    end
  end

  def activate_items
    items.each do |item|
      item.update(active?: true)
    end
  end
end
