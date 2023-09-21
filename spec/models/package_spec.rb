# frozen_string_literal: true

require "spec_helper"

RSpec.describe Package do
  it "validates the presence of name" do
    package = Package.new(name: nil)
    expect(package.validate).to eq(false)
    expect(package.errors[:name]).to be_present
  end

  it "validates the presence of price_cents" do
    package = Package.new(price_cents: nil)
    expect(package.validate).to eq(false)
    expect(package.errors[:price_cents]).to be_present
  end

  it "validates the price_for method when package municipality is blank" do
    package = Package.new(name: "Test", price_cents: 100)
    expect(package.price_for(nil)).to eq(100)
  end

  it "validates the price_for method when package municipality is present" do
    package = Package.new(name: "Test", price_cents: 200, municipality: "Stockholm")
    expect(package.price_for("Stockholm")).to eq(200)
  end

  it "validates the price_for method when package municipality is present but argument is nil" do
    package = Package.new(name: "Test", price_cents: 300, municipality: "Stockholm")
    expect(package.price_for(nil)).to eq(nil)
  end

  it "validates the price_for method when package municipality is blank but argument is present" do
    package = Package.new(name: "Test", price_cents: 400)
    expect(package.price_for("Stockholm")).to eq(nil)
  end

  it "validates the price_for method when package municipality is present and there are multiple prices" do
    package = Package.new(name: "Test", price_cents: 500, municipality: "Stockholm")
    UpdatePackagePrice.call(package, 555, municipality: "Göteborg")
    expect(package.price_for("Stockholm")).to eq(500)
    expect(package.price_for("Göteborg")).to eq(555)
    expect(package.price_for(nil)).to eq(nil)
    UpdatePackagePrice.call(package, 55)
    expect(package.price_for(nil)).to eq(55)
  end
end
