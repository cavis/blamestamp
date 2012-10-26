class Alligator < ActiveRecord::Base
  belongs_to :project
  has_many :flags
  attr_accessible :name, :project_id
  blameable :prefix => :gator, :cascade => :project, :required => true
end
