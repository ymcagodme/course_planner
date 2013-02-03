# == Schema Information
#
# Table name: departments
#
#  id         :integer          not null, primary key
#  abbr       :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Department do
  before(:each) do
    @attr = {
      abbr: "AED",
      name: "Adult Education"
    }
  end

  it "should not be a valid department with invalid attributes" do
    department = Department.new(@attr.merge!(abbr: "", name: ""))
    department.should_not be_valid
  end

  it "should be a valid department with the valid attributes" do
    department = Department.new(@attr)
    department.should be_valid
  end

  it "should create a department with valid attributes" do
    lambda do
      Department.create!(@attr)
    end.should change(Department, :count).by(1)
  end

  it "should have respond to courses" do
    department = Department.create!(@attr)
    department.should be_respond_to(:courses)
  end

  it "should be unique" do
    department = Department.create!(@attr)
    duplicated_department = Department.new(@attr)
    duplicated_department.should_not be_valid
  end
end
