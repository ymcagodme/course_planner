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
end
