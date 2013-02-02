# == Schema Information
#
# Table name: terms
#
#  id         :integer          not null, primary key
#  code       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  year       :integer
#  season     :string(255)
#

class Term < ActiveRecord::Base
  VALID_SEASON = %w[SPRING SUMMER FALL WINTER]
  attr_accessible :code, :year, :season
  has_many :courses

  validates :code, :presence => true,
                   :uniqueness => true,
                   :numericality => true

  validates :year, :presence => true,
                   :numericality => true

  validates :season, :presence => true,
                     :inclusion => {:in => VALID_SEASON}

  def name
    "#{year} #{season.upcase}"
  end
end
