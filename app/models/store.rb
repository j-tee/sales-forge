class Store < ApplicationRecord
  belongs_to :user
  has_many :stocks
  has_many :notifications

  def cost_of_expired_products
    expired = 0
    stocks.each do |stock|
      expired += stock.product.cost_of_expired_products
    end
    expired
  end


  def total_cost
    total_cost = 0
    stocks.each do |stock|
      total_cost += stock.total_cost
    end
    total_cost
  end

  def cost_of_damages
    damages = 0
    stocks.each do |stock|
      damages += stock.product.cost_of_damages
    end
    damages
  end

  def expected_revenue
    revenue = 0
    stocks.each do |stock|
      revenue += stock.product.expected_revenue
    end
    revenue
  end

  def actual_revenue
    revenue = 0
    stocks.each do |stock|
      revenue += stock.product.actual_revenue
    end
    revenue
  end

  def damages
    qty = 0
    stocks.each do |stock|
      qty += stock.damages
    end
    qty
  end

  def expired
    qty = 0
    stocks.each do |stock|
      qty += stock.expired
    end
    qty
  end
end
