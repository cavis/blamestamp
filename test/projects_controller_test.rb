require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  test "logged-out stamps on create" do
    create_project("foo", "bar")
    assert @project.blame_cre_at, "created_at not set"
    assert_nil @project.blame_cre_by, "created_by was set"
    assert_nil @project.blame_upd_at, "updated_at was set"
    assert_nil @project.blame_upd_by, "updated_by was set"
  end

  test "logged-in stamps on create" do
    sign_in :user, users(:harold)
    create_project("foo", "bar")
    assert @project.blame_cre_at, "created_at not set"
    assert @project.blame_cre_by, "created_by not set"
    assert_nil @project.blame_upd_at, "updated_at was set"
    assert_nil @project.blame_upd_by, "updated_by was set"
  end

  test "logged-out stamps on update" do
    update_project(projects(:secret), "foo", "bar")
    assert_equal projects(:secret).blame_cre_at, @project.blame_cre_at, "created_at changed"
    assert_equal projects(:secret).blame_cre_by, @project.blame_cre_by, "created_by changed"
    assert @project.blame_upd_at, "updated_at not set"
    assert_nil @project.blame_upd_by, "updated_by was set"
  end

  test "logged-in stamps on update" do
    sign_in :user, users(:harold)
    update_project(projects(:secret), "foo", "bar")
    assert_equal projects(:secret).blame_cre_at, @project.blame_cre_at, "created_at changed"
    assert_equal projects(:secret).blame_cre_by, @project.blame_cre_by, "created_by changed"
    assert @project.blame_upd_at, "updated_at not set"
    assert_equal users(:harold).id, @project.blame_upd_by, "updated_by not harold"
  end

  test "relationships are set" do
    sign_in :user, users(:harold)
    create_project("foo", "bar")
    assert_equal users(:harold).email, @project.blame_cre_user.email, "created email differs"
    assert_nil @project.blame_upd_user, "updated user exists"

    sign_out :user
    sign_in :user, users(:isak)
    update_project(@project, "foo", "bar2")
    assert_equal users(:isak).email, @project.blame_upd_user.email, "updated email differs"
  end

  private

  # helper to create and set a new project
  def create_project(title, desc)
    post :create, :project => {:title => title, :desc => desc}
    assert_response :redirect, "create didn't redirect"
    @project = assigns(:project)
  end

  # helper to update and set an existing project
  def update_project(prj, title, desc)
    put :update, :id => prj.id, :project => {:title => title, :desc => desc}
    assert_response :redirect, "update didn't redirect"
    @project = assigns(:project)
  end
end
