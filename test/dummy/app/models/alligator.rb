class Alligator < ActiveRecord::Base
  belongs_to :project
  attr_accessible :name

  blameable :prefix => :gator, :cascade => :project
end
