class UserCourseshipsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @course = Course.find(params[:user_courseship][:course_id])
    current_user.follow!(@course)
    respond_to do |format|
      format.html { redirect_to courses_path }
      format.js
    end
  end

  def destroy
    @course = UserCourseship.find(params[:id]).course
    current_user.unfollow!(@course)
    respond_to do |format|
      format.html { redirect_to courses_path }
      format.js
    end
  end
end
