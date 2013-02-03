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
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  term_id         :integer
#  department_id   :integer
#  code            :string(255)
#

require 'spec_helper'

describe Course do
  describe "Get all courses" do
    before(:each) do
      @term = FactoryGirl.create(:term)
      @department = FactoryGirl.create(:department)
      @course = FactoryGirl.create(:course, 
                                   :term => @term,
                                   :department => @department)
      @course1 = FactoryGirl.create(:course,
                                    :code => FactoryGirl.generate(:code), 
                                    :updated_at => Time.now + 2.days,
                                    :term => @term,
                                    :department => @department)
      @course2 = FactoryGirl.create(:course,
                                    :code => FactoryGirl.generate(:code), 
                                    :updated_at => Time.now + 23.days,
                                    :term => @term,
                                    :department => @department)
    end

    it "should have the right order by updated_at with DESC" do
      Course.all.should == [@course2, @course1, @course]
    end
  end

  describe "Create" do
    before(:each) do
      @attr = { code: 10231, 
                number: 300,
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

  describe "belongs_to department" do
    before(:each) do
      @department = FactoryGirl.create(:department)
      @course = FactoryGirl.create(:course, 
                                   :term => @term,
                                   :department => @department)
    end
    it "should respond to department" do
      @course.should be_respond_to(:department)
      @course.department.should eq(@department)
    end
  end
end
