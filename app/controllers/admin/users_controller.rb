class Admin::UsersController < AdminController
  before_action :load_user, only: [:edit, :update]
  def index
    @users = User.admin_panel_users
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    @user.save
    respond_with :edit, :admin, @user
  end

  def edit

  end

  def update
    @user.update user_params
    respond_with :edit, :admin, @user
  end

private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation, :role
  end

  def load_user
    @user = User.find_by id: params[:id]
  end

end
