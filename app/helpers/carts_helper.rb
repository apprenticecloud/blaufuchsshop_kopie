module CartsHelper
  def position(product)
    if @cart.new_record?
      create_position product, teacher_edition: false
    else
      variant = product.product_variants.find_by(teacher_edition: false)
      pos = @cart.positions.find_by(product_variant_id: variant.id)
      pos || create_position(product, teacher_edition: false)
    end
  end

  def teacher_position(product)
    if @cart.new_record?
      create_position product, teacher_edition: true
    else
      variant = product.product_variants.find_by(teacher_edition: true)
      pos = @cart.positions.find_by(product_variant_id: variant.id)
      pos || create_position(product, teacher_edition: true)
    end
  end

  def create_position(product, params)
    variant = product.product_variants.find_by(params)
    @cart.positions.build(product_variant_id: variant.id)
  end
end
