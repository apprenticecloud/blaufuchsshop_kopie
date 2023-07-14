class Position < ActiveRecord::Base
  after_initialize :set_default_values

  before_validation :set_unit_price, on: :create

  belongs_to :cart

  belongs_to :product_variant

  validates :product_variant, presence: true

  validates :cart, presence: true

  validates :amount, presence: true

  validates :amount, numericality: { greater_than_or_equal_to: 1 }

  def product
    product_variant.product if product_variant
  end

  def teacher_edition?
    product_variant.teacher_edition if product_variant
  end

  def update_unit_price(charge_with_reduced_price)
    # teachers' editions are free
    if teacher_edition?
      self.unit_price = 0
    else
      if charge_with_reduced_price
        self.unit_price = product.reduced_price
      else
        self.unit_price = product.price
      end
    end

    self.save
  end

  def set_unit_price
    if cart && unit_price.nil?
      self.update_unit_price(cart.charge_reduced_prices?)
    end
  end

  private
    def set_default_values
      self.amount ||= 0
    end
end