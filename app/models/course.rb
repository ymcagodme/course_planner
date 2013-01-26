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

class Course < ActiveRecord::Base
  has_many :user_courseships, :dependent => :delete_all
  has_many :users, :through => :user_courseships 

  attr_accessible :number, :title, :instructor, :status, :available_seats, :term

  validates_presence_of :number, :title, :status
  validates_numericality_of :number
  validates_uniqueness_of :number

  default_scope :order => 'courses.updated_at DESC'
end
