require 'spec_helper'

describe UserCourseshipsController do
  render_views

  describe "POST 'create'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @course = FactoryGirl.create(:course)
      test_sign_in(@user)
    end

    it "should be success" do
      post :create, :user_courseship => { :course_id => @course.id }
      response.should redirect_to(courses_path)
    end

    it "should create a relationship" do
      lambda do
        post :create, :user_courseship => { :course_id => @course.id }
      end.should change(UserCourseship, :count).by(1)
    end

    describe "Ajax" do
      it "should be success and create a relationship" do
        lambda do
          xhr :post, :create, :user_courseship => { :course_id => @course.id }
          response.should be_success
        end.should change(UserCourseship, :count).by(1)
      end
    end

  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @course = FactoryGirl.create(:course)
      test_sign_in(@user)
      @user.follow!(@course)
      @usercourseship = @user.user_courseships.find_by_course_id(@course)
    end

    it "should be success" do
      delete :destroy, :id => @usercourseship
      response.should redirect_to(courses_path)
    end

    it "should delete the relationship" do
      lambda do
        delete :destroy, :id => @usercourseship
      end.should change(UserCourseship, :count).by(-1)
    end

    describe "Ajax" do
      it "should be success and delete a relationship" do
        lambda do
          xhr :delete, :destroy, :id => @usercourseship
          response.should be_success
        end.should change(UserCourseship, :count).by(-1)
      end
    end
  end

  describe "authorization" do

    describe "POST 'create'" do

      it "should deny non-signed-in user" do
        post :create
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "DELETE 'destroy'" do
      
      it "should deny non-signed-in user" do
        delete :destroy, :id => 1
        response.should redirect_to(new_user_session_path)
      end
    end
  end
end
