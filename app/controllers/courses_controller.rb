class CoursesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]

  def index
    @courses = Course.paginate(:page => params[:page])
  end

  def show
    @course = Course.find(params[:id])
  end
end
