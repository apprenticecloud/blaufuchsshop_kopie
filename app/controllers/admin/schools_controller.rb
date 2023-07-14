class Admin::SchoolsController < AdminController
  before_action :load_school, only: [:edit, :update, :destroy]

  def index
    @schools = School.all
  end

  def new
    @school = School.new
    @address = @school.build_address
  end

  def create
    @school = School.new(school_params)
    @school.save
    respond_with :edit, :admin, @school
  end

  def edit
    @address = @school.address
  end

  def update
    @school.update school_params
    respond_with :edit, :admin, @school
  end

  def destroy
    @school.destroy
    flash[:danger] = @school.errors.full_messages.join(', ') if @school.persisted?

    redirect_to admin_schools_path
  end

private

  def school_params
    params.require(:school). permit :name, address_attributes: [ :address_locality, :street_address, :postal_code]
  end

  def load_school
    @school = School.find(params[:id])
  end
end