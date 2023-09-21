class AddMunicipalityToPackages < ActiveRecord::Migration[7.0]
  def change
    add_column :packages, :municipality, :string
  end
end
