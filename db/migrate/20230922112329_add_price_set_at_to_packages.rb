class AddPriceSetAtToPackages < ActiveRecord::Migration[7.0]
  def change
    add_column :packages, :price_set_at, :datetime
  end
end
