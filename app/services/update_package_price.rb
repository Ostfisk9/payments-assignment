# frozen_string_literal: true

class UpdatePackagePrice
  def self.call(package, new_price_cents, **options)
    Package.transaction do
      # Add a pricing history record
      Price.create!(package: package, price_cents: package.price_cents, municipality: package.municipality, price_set_at: package.price_set_at)

      # Update the latest price and municipality
      package.update!(price_cents: new_price_cents, municipality: options[:municipality], price_set_at: Time.current)
    end
  end
end
