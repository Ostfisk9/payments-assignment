class AddMunicipalityToPrices < ActiveRecord::Migration[7.0]
  def change
    add_column :prices, :municipality, :string
  end
end
