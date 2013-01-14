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

class Course < ActiveRecord::Base
  attr_accessible :number, :title, :instructor, :status, :available_seats, :term

  validates_presence_of :number, :title, :status
  validates_numericality_of :number
  validates_uniqueness_of :number
end
