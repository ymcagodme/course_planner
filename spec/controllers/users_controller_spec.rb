require 'spec_helper'

describe UsersController do
  describe "validation" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @course = FactoryGirl.create(:course)
      @attr = {
        user_id:   @user.id,
        course_id: @course.id
      }
    end

    it "should create a relationship given a valid attribute" do
      UserCourseship.create!(@attr)
    end

    it "should require an user_id" do
      relationship = UserCourseship.new(@attr.merge(:user_id => ""))
      relationship.should_not be_valid
    end

    it "should require an course_id" do
      relationship = UserCourseship.new(@attr.merge(:course_id => ""))
      relationship.should_not be_valid
    end
  end

  describe "dependency" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @course = FactoryGirl.create(:course)
      @relationship = UserCourseship.create!({ user_id: @user.id, course_id: @course })
    end

    it "should delete the relationship if the user is deleted" do
      lambda do
        @user.destroy
      end.should change(UserCourseship, :count).by(-1)
    end

    it "should delete the relationship if the course is deleted" do
      lambda do
        @course.destroy
      end.should change(UserCourseship, :count).by(-1)
    end
  end
end
