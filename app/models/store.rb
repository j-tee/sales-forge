class Store < ApplicationRecord
  belongs_to :user
  has_many :stocks
  has_many :notifications

  def cost_of_expired_products
    expired = 0
    stocks.each do |stock|
      expired += stock.cost_of_expired_products
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
      damages += stock.cost_of_damages
    end
    damages
  end

  def expected_revenue
    revenue = 0
    stocks.each do |stock|
      revenue += stock.expected_revenue
    end
    revenue
  end

  def actual_revenue
    revenue = 0
    stocks.each do |stock|
      revenue += stock.actual_revenue
    end
    revenue
  end

  def cost_of_quantity_sold
    revenue = 0
    stocks.each do |stock|
      revenue += stock.cost_of_quantity_sold
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

  def expected_balance
    balance = 0
    stocks.each do |stock|
      balance += stock.expected_balance
    end
    balance
  end

  def bad_debt
    debt = 0
    stocks.each do |stock|
      debt += stock.bad_debt
    end
    debt
  end
end
