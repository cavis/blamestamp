class CreateAlligators < ActiveRecord::Migration
  def change
    create_table :alligators do |t|
      t.string :name
      t.integer :project_id

      # custom blamestamp prefix
      t.blamestamps :prefix => :gator
    end
  end
end
