# frozen_string_literal: true

class Package < ApplicationRecord
  has_many :prices, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :price_cents, presence: true

  # returns the price for specific municipality
  # if the requested municipality (m) is the latest set price with a municipality then
  # we just read from this instance, otherwise find the latest price set for that municipality (m)
  # returns nil if specified municipality (m) doesn't have a price

  def price_for(m)
    return price_cents if municipality == m # this also covers nils as both try's will return nil
    prices.where(municipality: m).try(:last).try(:price_cents)
  end
end
