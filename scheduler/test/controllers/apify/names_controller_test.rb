require 'test_helper'

module Apify::Scheduler
  class NamesControllerTest < ActionController::TestCase
    setup do
      @name = names(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:names)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create name" do
      assert_difference('Name.count') do
        post :create, name: { delay: @name.delay, description: @name.description, destination: @name.destination, pattern: @name.pattern, processes: @name.processes }
      end

      assert_redirected_to name_path(assigns(:name))
    end

    test "should show name" do
      get :show, id: @name
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @name
      assert_response :success
    end

    test "should update name" do
      patch :update, id: @name, name: { delay: @name.delay, description: @name.description, destination: @name.destination, pattern: @name.pattern, processes: @name.processes }
      assert_redirected_to name_path(assigns(:name))
    end

    test "should destroy name" do
      assert_difference('Name.count', -1) do
        delete :destroy, id: @name
      end

      assert_redirected_to names_path
    end
  end
end
