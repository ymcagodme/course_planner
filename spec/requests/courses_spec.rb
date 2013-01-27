require 'spec_helper'

describe "Courses" do

  before(:each) do
    admin = FactoryGirl.create(:admin)
    visit new_user_session_path
    fill_in :email,    :with => admin.email
    fill_in :password, :with => admin.password 
    click_button
  end

  describe "Add a new course" do
    
    describe "failure" do
      it "should not create a new course" do
        lambda do
          visit new_course_path
          fill_in "Number", :with => ""
          fill_in "Title",  :with => ""
          select "",        :from  => "Status"
          click_button
          response.should render_template('courses/new')
          response.should have_selector('div.alert-error')
        end.should_not change(Course, :count)
      end
    end

    describe "success" do
      it "should create a new course" do
        lambda do
          visit new_course_path
          fill_in "Number", :with => "23870"
          fill_in "Title",  :with => "This is the test data"
          select "OPEN",    :from => "Status"
          click_button
          response.should render_template('courses/show')
          response.should have_selector('div.alert-success')
        end.should change(Course, :count).by(1)
      end
    end
  end

end
