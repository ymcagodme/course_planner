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
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  term_id         :integer
#

class Course < ActiveRecord::Base
  VALID_STATUS = %w[OPEN CLOSE TENTATIVE WAITLIST CANCELLED] 
  has_many :user_courseships, :dependent => :delete_all
  has_many :users, :through => :user_courseships 
  belongs_to :term

  attr_accessible :number, :title, :instructor, :status, :available_seats, :term_id

  validates_presence_of :number, :title, :status
  validates_numericality_of :number
  validates_uniqueness_of :number

  validates :status, :inclusion => {:in => VALID_STATUS}

  default_scope :order => 'courses.updated_at DESC'
end
