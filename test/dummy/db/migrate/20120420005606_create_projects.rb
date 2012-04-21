class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text :desc

      # t.timestamps
      t.datetime :blame_cre_at#, :null => false
      t.datetime :blame_upd_at
      t.integer :blame_cre_by#, :null => false
      t.integer :blame_upd_by
    end
  end
end
