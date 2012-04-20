require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  test "logged-out stamps on create" do
    create_project("foo", "bar")
    assert @project.created_at, "created_at not set"
    assert_nil @project.created_by, "created_by was set"
    assert_nil @project.updated_at, "updated_at was set"
    assert_nil @project.updated_by, "updated_by was set"
  end

  test "logged-in stamps on create" do
    sign_in :user, users(:harold)
    create_project("foo", "bar")
    assert @project.created_at, "created_at not set"
    assert @project.created_by, "created_by not set"
    assert_nil @project.updated_at, "updated_at was set"
    assert_nil @project.updated_by, "updated_by was set"
  end

  test "logged-out stamps on update" do
    update_project(projects(:secret), "foo", "bar")
    assert_equal projects(:secret).created_at, @project.created_at, "created_at changed"
    assert_equal projects(:secret).created_by, @project.created_by, "created_by changed"
    assert @project.updated_at, "updated_at not set"
    assert_nil @project.updated_by, "updated_by was set"
  end

  test "logged-in stamps on update" do
    sign_in :user, users(:harold)
    update_project(projects(:secret), "foo", "bar")
    assert_equal projects(:secret).created_at, @project.created_at, "created_at changed"
    assert_equal projects(:secret).created_by, @project.created_by, "created_by changed"
    assert @project.updated_at, "updated_at not set"
    assert_equal users(:harold).id, @project.updated_by, "updated_by not harold"
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
