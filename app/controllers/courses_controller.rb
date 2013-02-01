class CoursesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  # Because of the following line, we don't need to declare @user/@users
  load_and_authorize_resource :except => [:index, :show]

  def index
    @courses = Course.paginate(:page => params[:page])
  end

  def show
    @course = Course.find(params[:id])
  end

  def new
  end

  def create
    if @course.save
      flash[:success] = "The course ##{@course.number} is created!"
      redirect_to @course
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @course.update_attributes(params[:course])
      flash[:success] = "The course ##{@course.number} is updated!"
      redirect_to @course
    else
      render :edit
    end
  end

  def destroy
    @course.destroy
    flash[:success] = "The course ##{@course.number} is deleted!"
    redirect_to courses_path
  end
end
