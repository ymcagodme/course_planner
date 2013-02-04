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
#  department_id   :integer
#  code            :string(255)
#

class Course < ActiveRecord::Base
  
  include ActiveModel::Dirty
  VALID_STATUS = ['closed', 'open', 'wait list', 'tentative', 'stop enrl', 'cancelled']
  has_many :user_courseships, :dependent => :delete_all
  has_many :users, :through => :user_courseships 
  belongs_to :term
  belongs_to :department

  attr_accessible :number, :title, :instructor, :status, :available_seats, :term_id,
                  :department_id, :code

  validates_presence_of :number, :title, :status, :number
  # validates_numericality_of :code
  validates_uniqueness_of :code

  validates :status, :inclusion => {:in => VALID_STATUS}

  default_scope :order => 'courses.updated_at DESC'
end
