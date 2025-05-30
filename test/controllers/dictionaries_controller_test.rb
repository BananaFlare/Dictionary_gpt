require "test_helper"

class DictionariesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dictionaries_index_url
    assert_response :success
  end

  test "should get new" do
    get dictionaries_new_url
    assert_response :success
  end

  test "should get show" do
    get dictionaries_show_url
    assert_response :success
  end
end
