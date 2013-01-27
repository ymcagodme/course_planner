class UsersController < ApplicationController
  before_filter :authenticate_user!
  # Because of the following line, we don't need to declare @user/@users
  load_and_authorize_resource

  def index
    # @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    # @user = User.find(params[:id])
    if @user.update_attributes(params[:user], :as => :admin)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    # user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end

  def courses
    @courses = @user.courses.paginate(:page => params[:page])
    render 'courses/index'
  end
end
