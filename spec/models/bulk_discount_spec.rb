require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  
  describe "validations" do
    it { should validate_presence_of :merchant_id }
    it { should validate_presence_of :minimum_item_quantity }
    it { should validate_presence_of :percent_discount }
  end
  
  describe "relationships" do
    it {should belong_to :merchant}
  end
end
