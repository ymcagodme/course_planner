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

class Department < ActiveRecord::Base
  attr_accessible :abbr, :name
  has_many :courses

  validates_presence_of :abbr, :name
  validates_uniqueness_of :abbr, :name
end
