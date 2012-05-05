class Project < ActiveRecord::Base
  has_many :alligators
  has_many :flags
  attr_accessible :desc, :title
  blameable
end
