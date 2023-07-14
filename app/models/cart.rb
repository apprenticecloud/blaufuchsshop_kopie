class Cart < ActiveRecord::Base
  has_many :positions, dependent: :destroy

  has_many :product_variants, through: :positions

  has_many :products, through: :product_variants

  has_one :customer
  has_one :order

  accepts_nested_attributes_for :positions, allow_destroy: true,
    reject_if: Proc.new { |attributes|
      exists = attributes['id'].present?
      empty = attributes['amount'].to_i <= 0
      attributes.merge!(_destroy: 1) if exists && empty
      !exists && empty
    }

  def number_of_ordered_products
    if positions.any?
      total = 0
      positions.each{ |position| total += position.amount }
      total
    else
      0
    end
  end

  def something_was_ordered?
    number_of_ordered_products > 0
  end

  def charge_reduced_prices?
    number_of_ordered_products >= Constant.klassensatz
  end
end
