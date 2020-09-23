class AddTitleToBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    add_column :bulk_discounts, :title, :string
  end
end
