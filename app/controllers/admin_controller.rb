class AdminController < ApplicationController
  layout 'admin'

  before_action :only_admins

private

  def only_admins
    unless current_user && current_user.role == 'admin'
      redirect_to root_path
    end
  end

  def admins_and_printery
    unless current_user && (current_user.role == 'admin' || current_user.role == 'printery')
      redirect_to root_path
    end
  end
end