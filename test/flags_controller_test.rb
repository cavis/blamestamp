require 'test_helper'

class FlagsControllerTest < ActionController::TestCase
  test "stamps on create" do
    sign_in :user, users(:harold)
    create_flag("foo", projects(:secret), alligators(:james))

    assert_not_nil @flag.made_at, "created_at not set"
    assert_equal users(:harold).id, @flag.made_by, "created_by not set"
    assert_nil @flag.changed_at, "updated_at was set"
    assert_nil @flag.hacked_by, "updated_by was set"

    assert_nil @flag.project.blame_cre_at, "project created_at was set"
    assert_nil @flag.project.blame_cre_by, "project created_by was set"
    assert_not_nil @flag.project.blame_upd_at, "project updated_at not set"
    assert_equal users(:harold).id, @flag.project.blame_upd_by, "project updated_by not set"

    assert_nil @flag.alligator.gator_cre_at, "gator created_at was set"
    assert_nil @flag.alligator.gator_cre_by, "gator created_by was set"
    assert_not_nil @flag.alligator.gator_upd_at, "gator updated_at not set"
    assert_equal users(:harold).id, @flag.alligator.gator_upd_by, "gator updated_by not set"
  end

  test "stamps on update" do
    sign_in :user, users(:isak)
    update_flag(flags(:semaphore), "foo")

    assert_not_nil @flag.changed_at, "updated_at not set"
    assert_equal users(:isak).id, @flag.hacked_by, "updated_by not set"

    assert_not_nil @flag.project.blame_upd_at, "project updated_at not set"
    assert_equal users(:isak).id, @flag.project.blame_upd_by, "project updated_by not set"

    assert_not_nil @flag.alligator.gator_upd_at, "gator updated_at not set"
    assert_equal users(:isak).id, @flag.alligator.gator_upd_by, "gator updated_by not set"
  end

  test "stamps on destroy" do
    sign_in :user, users(:cameron)
    destroy_flag(flags(:american))
    prj = Project.find(projects(:secret).id)
    gat = Alligator.find(alligators(:james).id)

    assert_not_nil prj.blame_upd_at, "project updated_at not set"
    assert_equal users(:cameron).id, prj.blame_upd_by, "project updated_by not set"

    assert_not_nil gat.gator_upd_at, "gator updated_at not set"
    assert_equal users(:cameron).id, gat.gator_upd_by, "gator updated_by not set"
  end

  private

  # helper to create and set a new flag
  def create_flag(orig, project, alligator)
    post :create, :flag => {:origin => orig, :project_id => project.id, :alligator_id => alligator.id}
    assert_response :redirect, "create didn't redirect"
    @flag = assigns(:flag)
  end

  # helper to update and set an existing flag
  def update_flag(flag, orig)
    put :update, :id => flag.id, :flag => {:origin => orig}
    assert_response :redirect, "update didn't redirect"
    @flag = assigns(:flag)
  end

  # helper to destroy an flag
  def destroy_flag(flag)
    put :destroy, :id => flag.id
    assert_response :redirect, "destroy didn't redirect"
  end
end
