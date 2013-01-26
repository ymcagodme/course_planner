# == Schema Information
#
# Table name: user_courseships
#
#  id         :integer          not null, primary key
#  user_id    :string(255)
#  course_id  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserCourseship < ActiveRecord::Base
  attr_accessible :course_id, :user_id
  belongs_to :user
  belongs_to :course

  validates_presence_of :user_id, :course_id
end
