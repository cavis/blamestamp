class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.string :type
      t.integer :project_id
      t.integer :alligator_id
    end
  end
end
