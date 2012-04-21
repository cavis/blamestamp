class Project < ActiveRecord::Base
  blameable
  attr_accessible :desc, :title
end
