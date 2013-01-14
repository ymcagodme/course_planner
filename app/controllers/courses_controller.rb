class CoursesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]

  def index
    @courses = Course.paginate(:page => params[:page])
  end

  def show
    @course = Course.find(params[:id])
  end

  def new
    authorize! :new, @course
    @course = Course.new
  end

  def create
    authorize! :create, @course
    @course = Course.new(params[:course])
    if @course.save
      redirect_to @course
    else
      render :new
    end
  end
end
