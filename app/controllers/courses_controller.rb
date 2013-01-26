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
      flash[:success] = 'The course is created!'
      redirect_to @course
    else
      render :new
    end
  end

  def edit
    authorize! :edit, @course
    @course = Course.find(params[:id])
  end

  def update
    authorize! :update, @course
    @course = Course.find(params[:id])
    if @course.update_attributes(params[:course])
      flash[:success] = 'The course is updated!'
      redirect_to @course
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @course
    @course = Course.find(params[:id])
    @course.destroy
    flash[:success] = 'The course is deleted!'
    redirect_to courses_path
  end
end
