require 'spec_helper'

describe "Users" do
  describe "User Sign-in" do
    it "should let users login" do
      user = FactoryGirl.create(:user)
      visit new_user_session_path
      fill_in :email,    with: user.email
      fill_in :password, with: user.password
      click_button 'Sign in'
      response.should have_selector('a', :href => destroy_user_session_path,
                                         :content => 'Logout')
    end
  end
end
