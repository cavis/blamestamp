class Alligator < ActiveRecord::Base
  belongs_to :project
  attr_accessible :name
end
