class Flag < ActiveRecord::Base
  belongs_to :project
  belongs_to :alligator
  attr_accessible :type
end
