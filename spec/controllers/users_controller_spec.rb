require 'spec_helper'

describe UsersController do
  render_views

  describe "relationship with courses" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @course = FactoryGirl.create(:course)
      @relationship = UserCourseship.create!({ user_id: @user.id, course_id: @course.id })
      test_sign_in(@user)
    end

    it "should have a page to render followed courses" do
      get :courses, :id => @user
      response.should render_template('courses/index')
    end
  end

  describe "Get 'index'" do
    it "should deny non-signed-in users" do
      get :index
      response.should redirect_to(new_user_session_path)
    end

    it "should only display itself for non-admin users" do
      @admin = FactoryGirl.create(:admin)
      test_sign_in(FactoryGirl.create(:user))
      get :index
      response.should_not have_selector('a', :href => user_path(@admin),
                                             :content => @admin.name)
    end

    describe "Admin signed-in" do

      before(:each) do
        FactoryGirl.create(:user)
        test_sign_in(FactoryGirl.create(:admin))
      end

      it "should show all users" do
        pending
        #get :index
        #User.paginate(:page => 1).each do |user|
          #response.should_not have_selector('a', :href => user_path(user),
                                                 #:content => user.name)
        #end
      end
    end
  end
end
