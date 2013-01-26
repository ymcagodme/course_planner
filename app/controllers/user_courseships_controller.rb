class UserCourseshipsController < ApplicationController
  before_filter :authenticate_user!
end
