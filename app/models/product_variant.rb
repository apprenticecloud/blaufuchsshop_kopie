class ProductVariant < ActiveRecord::Base
  has_many :positions, dependent: :destroy
  belongs_to :product

  validates :product, presence: true

  def select_label
    if teacher_edition
      "#{product.title} - #{product.subtitle} (Lehrerexemplar)"
    else
      "#{product.title} - #{product.subtitle}"
    end
  end

  def product_price(charge_with_reduced_price)
    if teacher_edition
      0
    elsif charge_with_reduced_price
      product.reduced_price
    else
      product.price
    end
  end

  def self.options_for_select(charge_with_reduced_price)
    ProductVariant.all.map{|variant| [variant.select_label, variant.id, 
                                      { 'data-price' => variant.product_price(charge_with_reduced_price) }
                                      ]}
  end
end