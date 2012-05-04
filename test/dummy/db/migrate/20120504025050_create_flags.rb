class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.string :origin
      t.integer :project_id
      t.integer :alligator_id

      # custom blamestamp fields
      t.datetime :made_at
      t.datetime :changed_at
      t.integer :made_by
      t.integer :hacked_by
    end
  end
end
