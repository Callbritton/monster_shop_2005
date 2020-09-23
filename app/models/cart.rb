class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item, discount = nil)
    if !discount.nil?
      (item.price * @contents[item.id.to_s]) * (0.01 * (100 - discount.percent_discount))
    else
      item.price * @contents[item.id.to_s]
    end
  end

  def total
    @contents.sum do |item_id,quantity|
      item = Item.find(item_id)
      discount = BulkDiscount.get_best(item.merchant_id, item, quantity)
      if discount == nil
        item.price * quantity
      else
        (item.price * quantity)* (0.01 * (100 - discount.percent_discount))
      end
        
    end
  end

  def add_quantity(item_id)
    @contents[item_id] += 1
  end

  def subtract_quantity(item_id)
    @contents[item_id] -= 1
  end

  def item_count(item_id)
    @contents[item_id.to_s]
  end

  def out_of_stock?(item_id)
    item_count(item_id) == Item.find(item_id).inventory
  end

  def modify(order)
    items.each do |item,quantity|
      discount = BulkDiscount.get_best(item.merchant_id, item, quantity)
      item.modify_item_inventory(item, quantity, :decrease)
      if discount == nil
        order.item_orders.create({
            item: item,
            quantity: quantity,
            price: item.price,
            status: "unfulfilled"
            })
      else
        discounted_price = item.price * (0.01 * (100 - discount.percent_discount))
        order.item_orders.create({
            item: item,
            quantity: quantity,
            price: discounted_price,
            status: "unfulfilled"
            })
      end
    end
  end
end
