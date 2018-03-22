require 'test_helper'

class UserThingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_thing = user_things(:one)
  end

  test "should get index" do
    get user_things_url, as: :json
    assert_response :success
  end

  test "should create user_thing" do
    assert_difference('UserThing.count') do
      post user_things_url, params: { user_thing: { name: @user_thing.name, user_id: @user_thing.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show user_thing" do
    get user_thing_url(@user_thing), as: :json
    assert_response :success
  end

  test "should update user_thing" do
    patch user_thing_url(@user_thing), params: { user_thing: { name: @user_thing.name, user_id: @user_thing.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy user_thing" do
    assert_difference('UserThing.count', -1) do
      delete user_thing_url(@user_thing), as: :json
    end

    assert_response 204
  end
end
