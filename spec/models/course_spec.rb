# == Schema Information
#
# Table name: courses
#
#  id              :integer          not null, primary key
#  number          :string(255)      not null
#  title           :string(255)
#  instructor      :string(255)
#  status          :string(255)
#  available_seats :integer          default(0)
#  term            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Course do
  describe "Get all courses" do
    before(:each) do
      @course = FactoryGirl.create(:course)
      @course1 = FactoryGirl.create(:course,
                                    :number => FactoryGirl.generate(:number), 
                                    :updated_at => Time.now + 2.days)
      @course2 = FactoryGirl.create(:course,
                                    :number => FactoryGirl.generate(:number), 
                                    :updated_at => Time.now + 23.days)
    end

    it "should have the right order by updated_at with DESC" do
      Course.all.should == [@course2, @course1, @course]
    end
  end

  describe "Create" do
    before(:each) do
      @attr = { number: 10231, 
                title: "CIS RoR",
                status: "CLOSE"}
    end

    describe "failure" do
      it "should not create a course with invalid number" do
        invalid_course = Course.new(@attr.merge!(number: 'adfs'))
        invalid_course.should_not be_valid
      end

      it "should not create a course with no title" do
        no_title_course = Course.new(@attr.merge!(title: ''))
        no_title_course.should_not be_valid
      end
    end

    describe "success" do
      it "should create a course with valid attributes" do
        lambda do
          course = Course.new(@attr)
          course.should be_valid
          course.save!
        end.should change(Course, :count).by(1)
      end
    end
  end
  
  describe "relationship with users" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @course = FactoryGirl.create(:course)
      @relationship = UserCourseship.create!({ user_id: @user.id, course_id: @course.id })
    end

    it "should delete the relationship if the course is deleted" do
      lambda do
        @course.destroy
      end.should change(UserCourseship, :count).by(-1)
    end
  end

end
