require 'test_helper'

class ShareViewsControllerTest < ActionController::TestCase
  setup do
    @share_view = share_views(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:share_views)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create share_view" do
    assert_difference('ShareView.count') do
      post :create, share_view: { share_id: @share_view.share_id, user_id: @share_view.user_id }
    end

    assert_redirected_to share_view_path(assigns(:share_view))
  end

  test "should show share_view" do
    get :show, id: @share_view
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @share_view
    assert_response :success
  end

  test "should update share_view" do
    put :update, id: @share_view, share_view: { share_id: @share_view.share_id, user_id: @share_view.user_id }
    assert_redirected_to share_view_path(assigns(:share_view))
  end

  test "should destroy share_view" do
    assert_difference('ShareView.count', -1) do
      delete :destroy, id: @share_view
    end

    assert_redirected_to share_views_path
  end
end
