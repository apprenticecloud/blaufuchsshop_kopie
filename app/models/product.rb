class Product < ActiveRecord::Base

  before_destroy :check_if_the_product_was_ordered

  after_create :create_product_variants

  has_many :product_variants, dependent: :destroy
  has_many :product_subject_selections, dependent: :destroy
  has_many :subjects, through: :product_subject_selections

  validates :title, presence: true
  validates :price, presence: true
  validates :weight, presence: true
  validates :reduced_price, presence: true
  validates :year, presence: true

  def was_ordered?
    Product.ordered_product_ids.include?(self.id)
  end

  def self.ordered_product_ids
    order_carts_ids = Order.pluck(:cart_id)
    order_product_variants_ids = Position.where(cart_id: order_carts_ids).pluck('DISTINCT product_variant_id')
    order_product_ids = ProductVariant.where(id: order_product_variants_ids).pluck('DISTINCT product_id')

    order_product_ids
  end

  private
    def create_product_variants
      product_variants.create! teacher_edition: true
      product_variants.create! teacher_edition: false
    end

    def check_if_the_product_was_ordered
      if was_ordered?
        errors.add :base, :product_was_ordered
        return false
      end
    end
end
