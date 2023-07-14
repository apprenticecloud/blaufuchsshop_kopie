class Admin::ProductsController < AdminController
  before_action :load_product, only: [:edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    @product.save
    respond_with :edit, :admin, @product
  end

  def update
    @product.update product_params
    respond_with :edit, :admin, @product
  end

  def destroy
    if @product.destroy
      flash[:alert] = @product.errors.full_messages.join(', ') if @product.persisted?

      redirect_to admin_products_path
    else
      flash[:alert] = 'Fehler. Konnte Objekt nicht löschen. Evtl. gibt es noch bestehende Verknüpfungen zu anderen Daten.'
      redirect_to admin_products_path
    end
  end

private
  def product_params
    params.require(:product).permit :title, :subtitle, :description, :price,
      :reduced_price, :year, :image, :weight, :hide_student_edition, :hide_teacher_edition, subject_ids: []
  end

  def load_product
    @product = Product.find(params[:id])
  end
end