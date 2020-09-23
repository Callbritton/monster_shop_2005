class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  
  validates_presence_of :merchant_id,
                        :minimum_item_quantity,
                        :percent_discount
                        
  def self.get_best(merchant_id, item, quantity)
    discounts = self.where("merchant_id = ?", merchant_id)
    if !discounts.nil?
      @savings = Hash.new
      discounts.each do |discount|
        if discount.meet_minimum?(quantity, discount.minimum_item_quantity)
          @savings[discount.id] = (quantity * item.price) - (item.price * (quantity * (discount.percent_of_total)))
        end
      end
    end
    if !@savings.empty?
      BulkDiscount.find(@savings.max_by{|k,v| v}.first)
    end
  end
  
  def meet_minimum?(quantity, minimum_quantity)
    quantity >= minimum_quantity
  end
  
  def percent_of_total
    0.01 * (100 - percent_discount)
  end
end
