require 'spec_helper'

describe CoursesController do
  render_views

  before(:each) do
    @course = FactoryGirl.create(:course)
    @course1 = FactoryGirl.create(:course,
                                  :number => FactoryGirl.generate(:number), 
                                  :updated_at => Time.now - 2.days)
    @course2 = FactoryGirl.create(:course,
                                  :number => FactoryGirl.generate(:number), 
                                  :updated_at => Time.now - 23.days)
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

    it "should hide the edit and delete buttons" do
      get :index
      response.should_not have_selector('a', :content => 'Edit',
                                             :href => edit_course_path(@course))
      response.should_not have_selector('a', :content => 'Delete',
                                             :href => course_path(@course))
    end

    it "should not have an add a new course button" do
      get :index
      response.should_not have_selector('a', :content => 'Add a new course',
                                             :href    => new_course_path)
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

      it "should not have an add a new course button" do
        get :index
        response.should_not have_selector('a', :content => 'Add a new course',
                                               :href    => new_course_path)
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

      it "should have an add new course button" do
        get :index
        response.should have_selector('a', :content => 'Add a new course',
                                           :href    => new_course_path)
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

    it "should reject signed-in user" do
      test_sign_in(FactoryGirl.create(:user))
      get :new
      response.should redirect_to(root_path)
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

      describe "failure" do

        before(:each) do
          @invalid_attr = @attr.merge(:number => '', :title => '', :status => '')
        end

        it "should deny the invalid attributes" do
          post :create, :course => @invalid_attr
          response.should have_selector('div', :content => 'Please review the problems below',
                                               :class => 'alert alert-error')
        end

        it "should render 'new' page" do
          post :create, :course => @invalid_attr
          response.should render_template('new')
        end
      end

      describe "success" do
        it "should create a course" do
          lambda do
            post :create, :course => @attr
          end.should change(Course, :count).by(1)
        end

        it "should redirect to the course page" do
          post :create, :course => @attr
          response.should redirect_to(assigns(:course))
        end

        it "should have a flash message" do
          post :create, :course => @attr
          flash[:success].should =~ /\d+.+is.+created!/i
        end
      end
    end
  end

  describe "GET 'edit'" do
    it "should reject non-signed-in user" do
      get :edit, :id => ''
      response.should redirect_to(new_user_session_path)
    end

    it "should reject non-admin user" do
      test_sign_in(FactoryGirl.create(:user))
      get :edit, :id => @course
      response.should redirect_to(root_path)
    end

    describe "admin user" do

      before(:each) do
        test_sign_in(FactoryGirl.create(:admin))
      end

      it "should be successful" do
        get :edit, :id => @course
        response.should be_success
      end

      it "should have the right title" do
        get :edit, :id => @course
        response.should have_selector('title', :content => 'Edit')
      end

      it "should have a Update button" do
        get :edit, :id => @course
        response.should have_selector('input', :value => 'Update')
      end
    end
  end

  describe "PUT 'update'" do
    it "should deny non-signed-in user" do
      put :update, :id => '', :course => {}
      response.should redirect_to(new_user_session_path)
    end

    it "should deny non-admin user" do
      test_sign_in(FactoryGirl.create(:user))
      put :update, :id => @course, :course => {}
      response.should redirect_to(root_path)
    end

    describe "Admin user" do

      before(:each) do
        test_sign_in(FactoryGirl.create(:admin))
      end

      describe "failure" do
        before(:each) do
          @attr = { :number => '', :title => '', :status => '' }
        end

        it "should render the 'edit' page" do
          put :update, :id => @course, :course => @attr
          response.should render_template('edit')
        end
      end

      describe "success" do
        it "should successfully update the course" do
          put :update, :id => @course, :course => {:number => '12349'}
          course = assigns(:course)
          @course.reload
          @course.number.should == course.number
        end

        it "should have a flash message" do
          put :update, :id => @course, :course => {:number => '12349'}
          flash[:success].should =~ /\d+.+is.+updated/i
        end
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "should deny non-signed-in user" do
      delete :destroy, :id => @course
      response.should redirect_to(new_user_session_path)
    end

    it "should deny non-admin user" do
      test_sign_in(FactoryGirl.create(:user))
      delete :destroy, :id => @course
      response.should redirect_to(root_path)
    end

    describe "admin" do
      before(:each) do
        test_sign_in(FactoryGirl.create(:admin))
      end

      it "should successfully delete the course" do
        lambda do
          delete :destroy, :id => @course
        end.should change(Course, :count).by(-1)
      end

      it "should rediect to course index page" do
        delete :destroy, :id => @course
        response.should redirect_to(courses_path)
      end

      it "should have a flash message" do
        delete :destroy, :id => @course
        flash[:success].should =~ /\d+.+is.+deleted!/i
      end
    end
  end
end
