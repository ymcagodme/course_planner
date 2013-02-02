# == Schema Information
#
# Table name: user_courseships
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  course_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe UserCourseship do

  before(:each) do
    user = FactoryGirl.create(:user)
    course = FactoryGirl.create(:course)
    @attr = {
      user_id:   user.id,
      course_id: course.id
    }
  end

  it "should create a relationship with valid attributes" do
    UserCourseship.create!(@attr)
  end

  it "should not create a relationship with no user_id" do
    relationship = UserCourseship.new(@attr.merge(user_id: ""))
    relationship.should_not be_valid
  end

  it "should not create a relationship with no course_id" do
    relationship = UserCourseship.new(@attr.merge(course_id: ""))
    relationship.should_not be_valid
  end
end
