class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text :desc

      # stamps
      # t.timestamps
      t.datetime :created_at#, :null => false
      t.datetime :updated_at
      t.integer :created_by#, :null => false
      t.integer :updated_by
    end
  end
end
