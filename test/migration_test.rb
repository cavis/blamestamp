require 'test_helper'

class MigrationTest < ActiveSupport::TestCase
  test "default migration helper" do
    assert Project.column_names.include?("blame_cre_at"), "doesn't include cre_at"
    assert Project.column_names.include?("blame_upd_at"), "doesn't include upd_at"
    assert Project.column_names.include?("blame_cre_by"), "doesn't include cre_by"
    assert Project.column_names.include?("blame_upd_by"), "doesn't include upd_by"
  end

  test "prefix option on migration helper" do
    assert Alligator.column_names.include?("gator_cre_at"), "doesn't include cre_at"
    assert Alligator.column_names.include?("gator_upd_at"), "doesn't include upd_at"
    assert Alligator.column_names.include?("gator_cre_by"), "doesn't include cre_by"
    assert Alligator.column_names.include?("gator_upd_by"), "doesn't include upd_by"
  end

  test "custom fields migration" do
    assert Flag.column_names.include?("made_at"), "doesn't include cre_at"
    assert Flag.column_names.include?("changed_at"), "doesn't include upd_at"
    assert Flag.column_names.include?("made_by"), "doesn't include cre_by"
    assert Flag.column_names.include?("hacked_by"), "doesn't include upd_by"
  end
end
