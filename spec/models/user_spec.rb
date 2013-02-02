# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string(255)
#

require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      name: 'Test',
      email: 'test@huang.com.tw',
      password: '123123', 
      password_confirmation: '123123'
    }
  end

  describe "failure" do

    it "should not create a user with an invalid email" do
      user = User.new(@attr.merge!(email: 'test@test'))
      user.should_not be_valid
    end

    it "should not create a user with too short password" do
      user = User.new(@attr.merge!(password: '123', password_confirmation: '123'))
      user.should_not be_valid
    end

    it "should not create a user with no name" do
      no_name_user = User.new(@attr.merge!(name: ''))
      no_name_user.should_not be_valid
    end

    it "should reject names that are too long" do
      long_name = 'a' * 51
      long_name_user = User.new(@attr.merge!(name: long_name))
      long_name_user.should_not be_valid
    end
  end

  describe "success" do
    it "should create a user with valid attributes" do
      user = User.new(@attr)
      user.should be_valid
    end
  end

  describe "relationship with courses" do
    before(:each) do
      @term = FactoryGirl.create(:term)
      @user = FactoryGirl.create(:user)
      @course1 = FactoryGirl.create(:course,
                                    :number => FactoryGirl.generate(:number),
                                    :term => @term)
      @course2 = FactoryGirl.create(:course,
                                    :number => FactoryGirl.generate(:number),
                                    :updated_at => Time.now + 3.hours,
                                    :term => @term)
      @course3 = FactoryGirl.create(:course,
                                    :number => FactoryGirl.generate(:number),
                                    :updated_at => Time.now - 6.hours,
                                    :term => @term)
      UserCourseship.create!(user_id: @user.id, course_id: @course1.id)
      UserCourseship.create!(user_id: @user.id, course_id: @course2.id)
      UserCourseship.create!(user_id: @user.id, course_id: @course3.id)
    end

    it "should have the right order by updated_at with DESC" do
      @user.courses.should == [@course2, @course1, @course3]
    end

    it "should delete the relationship if the user is deleted" do
      lambda do
        @user.destroy
      end.should change(UserCourseship, :count).by(-3)
    end
  end

end
