require "test_helper"

class UserInteractionControllerTest < ActionDispatch::IntegrationTest
  test "should get include_words" do
    get user_interaction_include_words_url
    assert_response :success
  end

  test "should get exclude_words" do
    get user_interaction_exclude_words_url
    assert_response :success
  end
end
