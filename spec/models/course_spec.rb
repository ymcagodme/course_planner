# == Schema Information
#
# Table name: courses
#
#  id              :integer          not null, primary key
#  number          :integer
#  title           :string(255)
#  instructor      :string(255)
#  status          :string(255)
#  available_seats :integer
#  term            :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Course do


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
        course = Course.new(@attr)
        course.should be_valid
      end
    end
  end

end
