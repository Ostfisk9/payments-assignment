class AddPriceSetAtToPrices < ActiveRecord::Migration[7.0]
  def change
    add_column :prices, :price_set_at, :datetime
  end
end
