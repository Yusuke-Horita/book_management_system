require 'test_helper'

class Admins::CheckOutsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admins_check_outs_index_url
    assert_response :success
  end

  test "should get show" do
    get admins_check_outs_show_url
    assert_response :success
  end

  test "should get edit" do
    get admins_check_outs_edit_url
    assert_response :success
  end

end
