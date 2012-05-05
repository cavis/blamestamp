require 'test_helper'

class AlligatorsControllerTest < ActionController::TestCase
  test "stamps on create" do
    sign_in :user, users(:harold)
    create_alligator("foo", projects(:secret))

    assert_not_nil @alligator.gator_cre_at, "created_at not set"
    assert_equal users(:harold).id, @alligator.gator_cre_by, "created_by not set"
    assert_nil @alligator.gator_upd_at, "updated_at was set"
    assert_nil @alligator.gator_upd_by, "updated_by was set"

    assert_nil @alligator.project.blame_cre_at, "project created_at was set"
    assert_nil @alligator.project.blame_cre_by, "project created_by was set"
    assert_not_nil @alligator.project.blame_upd_at, "project updated_at not set"
    assert_equal users(:harold).id, @alligator.project.blame_upd_by, "project updated_by not set"
  end

  test "stamps on update" do
    sign_in :user, users(:isak)
    update_alligator(alligators(:james), "foo")

    assert_not_nil @alligator.gator_upd_at, "updated_at not set"
    assert_equal users(:isak).id, @alligator.gator_upd_by, "updated_by not set"

    assert_not_nil @alligator.project.blame_upd_at, "project updated_at not set"
    assert_equal users(:isak).id, @alligator.project.blame_upd_by, "project updated_by not set"
  end

  test "stamps on destroy" do
    sign_in :user, users(:cameron)
    destroy_alligator(alligators(:james))
    prj = Project.find(projects(:secret).id)

    assert_not_nil prj.blame_upd_at, "project updated_at not set"
    assert_equal users(:cameron).id, prj.blame_upd_by, "project updated_by not set"
  end

  private

  # helper to create and set a new alligator
  def create_alligator(name, project)
    post :create, :alligator => {:name => name, :project_id => project.id}
    assert_response :redirect, "create didn't redirect"
    @alligator = assigns(:alligator)
  end

  # helper to update and set an existing alligator
  def update_alligator(gat, name)
    put :update, :id => gat.id, :alligator => {:name => name}
    assert_response :redirect, "update didn't redirect"
    @alligator = assigns(:alligator)
  end

  # helper to destroy an alligator
  def destroy_alligator(gat)
    put :destroy, :id => gat.id
    assert_response :redirect, "destroy didn't redirect"
  end
end
