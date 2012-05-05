class Flag < ActiveRecord::Base
  belongs_to :project
  belongs_to :alligator
  attr_accessible :origin, :project_id, :alligator_id
  blameable :cre_at => :made_at,
    :upd_at => :changed_at,
    :cre_by => :made_by,
    :upd_by => :hacked_by,
    :cre_user => :maker,
    :upd_user => :hacker,
    :cascade => [:project, :alligator]
end
