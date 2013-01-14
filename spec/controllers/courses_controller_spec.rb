require 'spec_helper'

describe CoursesController do
  render_views

  before(:each) do
    @course = FactoryGirl.create(:course)
    @course1 = FactoryGirl.create(:course, :number => FactoryGirl.generate(:number) )
    @course2 = FactoryGirl.create(:course, :number => FactoryGirl.generate(:number) )
  end

  describe "GET 'index'" do
    it "should be success" do
      get :index
      response.should be_success
    end

    it "should have an element for each course" do
      get :index
      Course.paginate(:page => 1).each do |course|
        response.should have_selector('a', :content => course.number.to_s,
                                           :href => course_path(course) )
      end
    end

    it "should hide the edit and delete buttons" do
      get :index
      response.should_not have_selector('a', :content => 'Edit',
                                             :href => edit_course_path(@course))
      response.should_not have_selector('a', :content => 'Delete',
                                             :href => course_path(@course))
    end

    describe "User to index" do
      before(:each) do
        user = FactoryGirl.create(:user)
        test_sign_in(user)
      end

      it "should not have edit and delete buttons" do
        get :index
        response.should_not have_selector('a', :content => 'Edit',
                                               :href => edit_course_path(@course))
        response.should_not have_selector('a', :content => 'Delete',
                                               :href => course_path(@course))
      end
    end

    describe "Admin to index" do
      before(:each) do
        admin = FactoryGirl.create(:admin)
        test_sign_in(admin)
      end
      it "should have the edit and delete buttons for an admin user" do
        get :index
        Course.paginate(:page => 1).each do |course|
          response.should have_selector('a', :content => 'Edit',
                                             :href => edit_course_path(course) )
        response.should have_selector('a', :content => 'Delete',
                                           :href => course_path(@course))
        end
      end
    end
  end

  describe "GET 'show'" do
    it "should be success" do
      get :show, :id => @course1
      response.should be_success
    end

    it "should hide the edit and delete buttons" do
      get :show, :id => @course
      response.should_not have_selector('a', :content => 'Edit',
                                             :href => edit_course_path(@course))
      response.should_not have_selector('a', :content => 'Delete',
                                             :href => course_path(@course))
    end

    describe "User to show" do
      before(:each) do
        user = FactoryGirl.create(:user)
        test_sign_in(user)
      end

      it "should not have edit and delete buttons" do
        get :show, :id => @course
        response.should_not have_selector('a', :content => 'Edit',
                                               :href => edit_course_path(@course))
        response.should_not have_selector('a', :content => 'Delete',
                                               :href => course_path(@course))
      end
    end

    describe "Admin to show" do
      before(:each) do
        admin = FactoryGirl.create(:admin)
        test_sign_in(admin)
      end
      it "should have the edit and delete buttons for an admin user" do
        get :show, :id => @course
        response.should have_selector('a', :content => 'Edit',
                                           :href => edit_course_path(@course) )
        response.should have_selector('a', :content => 'Delete',
                                           :href => course_path(@course))
      end
    end
  end

  describe "GET 'new'" do
    it "should be success for an admin" do
      test_sign_in(FactoryGirl.create(:admin))
      get :new
      response.should be_success
    end

    it "should reject non-signed-in viewer" do
      get :new
      response.should redirect_to(new_user_session_path)
    end

    it "should reject general user" do
      get :new
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @attr = {
        number: '12234',
        title: 'CIS RoR',
        instructor: 'David',
        status: 'OPEN',
        available_seats: '30',
        term: '1131'
      }
    end

    it "should reject general user" do
      post :create, :course => {}
      response.should redirect_to(new_user_session_path)
    end

    it "should not create a course successfully" do
      lambda do
        post :create, :course => @attr
      end.should_not change(Course, :count)
    end

    describe "non-admin signed in" do
      before(:each) do
        user = FactoryGirl.create(:user)
        test_sign_in(user)
      end

      it "should deny non-admin from creating a course" do
        post :create, :course => {}
        response.should redirect_to(root_path)
      end

      it "should not create a course successfully" do
        lambda do
          post :create, :course => @attr
        end.should_not change(Course, :count)
      end
    end

    describe "admin signed-in" do

      before(:each) do
        test_sign_in(FactoryGirl.create(:admin))
      end

      it "should create a course" do
        lambda do
          post :create, :course => @attr
        end.should change(Course, :count).by(1)
      end

      it "should redirect to the course page" do
        post :create, :course => @attr
        response.should redirect_to(assigns(:course))
      end
    end
  end
end
