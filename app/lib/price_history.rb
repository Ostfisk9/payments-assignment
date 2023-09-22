# frozen_string_literal: true

class PriceHistory

  # gives the price history for a package based on year and municipality.
  # Only takes price from prices with the current year and from the package if its year
  # corresponds. But it is worth noting it also adds the package price if relevant to the
  # query.
  #
  # returns nil if no results
  def self.call(**args)
    beginning_of_year = Time.zone.local(args[:year]).beginning_of_year
    end_of_year = Time.zone.local(args[:year]).end_of_year

    package = args[:package]

    prices = package.prices
    prices = prices.where(price_set_at: beginning_of_year..end_of_year) if args[:year].present?
    prices = prices.where(municipality: args[:municipality]) if args[:municipality].present?

    prices_hash = if prices.present?
      prices.pluck(:municipality, :price_cents).group_by{ |price| price[0] }.transform_values{ |v| v.map(&:last) }
    else
      {}
    end

    if (package.price_set_at >= beginning_of_year && package.price_set_at <= end_of_year) &&
      (args[:municipality].blank? || package.municipality == args[:municipality])
      if  prices_hash[package.municipality].kind_of?(Array)
        prices_hash[package.municipality] << package.price_cents
      else 
        prices_hash[package.municipality] = [package.price_cents]
      end
    end
  
    prices_hash.presence
  end
end
