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

require 'spec_helper'

describe Term do
  before(:each) do
    @attr = {
      code: 1311,
      year: 2013,
      season: "Spring"
    }
  end

  it "should create a term with valid attributes" do
    term = Term.new(@attr)
    term.should be_valid
  end

  it "should respond to name method" do
    term = Term.create!(@attr)
    term.should respond_to(:name)
  end
end
