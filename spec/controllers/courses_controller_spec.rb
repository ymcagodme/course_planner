require 'spec_helper'

describe CoursesController do
  render_views

  before(:each) do
    @course = FactoryGirl.create(:course,
                                 :term => @term)
  end

  describe "GET 'index'" do
    it "should be success" do
      get :index
      response.should be_success
    end

    it "should have the right title" do
      get :index
      response.should have_selector('title', :content => 'All Courses')
    end

    it "should have an element for each course" do
      get :index
      Course.paginate(:page => 1).each do |course|
        response.should have_selector('a', :content => course.number.to_s,
                                           :href => course_path(course) )
      end
    end

    describe "User to index" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        test_sign_in(@user)
      end

      it "should have the notification buttons" do
        get :index
        Course.paginate(:page => 1).each do |course|
          if @user.in?(course.users)
            response.should have_selector("td##{course.id}>form>input", :value => "Unfollow")
          else
            response.should have_selector("td##{course.id}>form>input", :value => "Follow")
          end
        end
      end
    end
  end

  describe "GET 'show'" do
    it "should be success" do
      get :show, :id => @course
      response.should be_success
    end

    describe "User to show" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        test_sign_in(@user)
      end

      it "should have the right status for nitification button" do
        get :show, :id => @course
        if @user.in?(@course.users)
          response.should have_selector("td##{@course.id}>form>input", :value => "Unfollow")
        else
          response.should have_selector("td##{@course.id}>form>input", :value => "Follow")
        end
      end

    end
  end
end
