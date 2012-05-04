require 'test_helper'

class BlameableTest < ActiveSupport::TestCase
  test "default options" do
    assocs = Project.reflect_on_all_associations.collect {|a| a.name }
    assert assocs.include?(:blame_cre_user), "doesn't include cre_user"
    assert assocs.include?(:blame_upd_user), "doesn't include upd_user"

    p = projects(:secret)
    set_blamers(p, users(:harold), users(:isak))
    assert_equal p.blame_cre_user.email, users(:harold).email, "incorrect cre_user"
    assert_equal p.blame_upd_user.email, users(:isak).email, "incorrect upd_user"
  end

  test "prefix option" do
    assocs = Alligator.reflect_on_all_associations.collect {|a| a.name }
    assert assocs.include?(:gator_cre_user), "doesn't include cre_user"
    assert assocs.include?(:gator_upd_user), "doesn't include upd_user"

    a = alligators(:james)
    set_blamers(a, users(:harold), users(:isak))
    assert_equal a.gator_cre_user.email, users(:harold).email, "incorrect cre_user"
    assert_equal a.gator_upd_user.email, users(:isak).email, "incorrect upd_user"
  end

  test "non array cascade option" do
    a = alligators(:james)
    assert_nil a.project.blame_cre_user, "project already blame-created"
    assert_nil a.project.blame_upd_user, "project already blame-updated"

    set_blamers(a, users(:isak), users(:isak))

    assert_nil a.project.blame_cre_user, "project was blame-created"
    assert_not_nil a.project.blame_upd_user, "project not blame-updated"
    assert_equal a.project.blame_upd_user.email, users(:isak).email, "incorrect upd_user"
  end

  test "array cascade option" do
    f = flags(:american)
    assert_nil f.project.blame_cre_user, "project already blame-created"
    assert_nil f.project.blame_upd_user, "project already blame-updated"
    assert_nil f.alligator.gator_cre_user, "gator already blame-created"
    assert_nil f.alligator.gator_upd_user, "gator already blame-updated"

    set_blamers(f, users(:harold), users(:harold))

    assert_nil f.project.blame_cre_user, "project was blame-created"
    assert_not_nil f.project.blame_upd_user, "project not blame-updated"
    assert_equal f.project.blame_upd_user.email, users(:harold).email, "incorrect upd_user"
    assert_nil f.alligator.gator_cre_user, "gator was blame-created"
    assert_not_nil f.alligator.gator_upd_user, "gator not blame-updated"
    assert_equal f.alligator.gator_upd_user.email, users(:harold).email, "incorrect upd_user"
  end

  test "cre_at option" do
    f = Flag.new()
    assert_nil f.made_at, "already has cre_at"
    f.save()
    assert_not_nil f.made_at, "didn't set cre_at"
  end

  test "upd_at option" do
    f = flags(:semaphore)
    f.origin = "something else"
    assert_nil f.changed_at, "already has upd_at"
    f.save()
    assert_not_nil f.changed_at, "didn't set upd_at"
  end

  test "cre_by option" do
    f = Flag.new()
    assert_nil f.made_by, "already has cre_by"
    f.save()
    assert_not_nil f.made_by, "didn't set cre_by"
  end

  test "upd_by option" do
    f = flags(:semaphore)
    f.origin = "something else"
    assert_nil f.hacked_by, "already has upd_by"
    f.save()
    assert_not_nil f.hacked_by, "didn't set upd_by"
  end

  test "cre_user option" do
    assocs = Flag.reflect_on_all_associations.collect {|f| f.name }
    assert assocs.include?(:maker), "doesn't include cre_user"

    f = flags(:semaphore)
    set_blamers(f, users(:cameron), users(:cameron))
    assert_equal f.maker.email, users(:cameron).email, "incorrect cre_user"
  end

  test "upd_user option" do
    assocs = Flag.reflect_on_all_associations.collect {|f| f.name }
    assert assocs.include?(:hacker), "doesn't include upd_user"

    f = flags(:semaphore)
    set_blamers(f, users(:cameron), users(:cameron))
    assert_equal f.hacker.email, users(:cameron).email, "incorrect upd_user"
  end

  private

  def set_blamers(rec, cre_user, upd_user)
    Blamestamp::set_blame_user(cre_user.id)
    rec.blame_create()
    Blamestamp::set_blame_user(upd_user.id)
    rec.blame_update()
  end

end
