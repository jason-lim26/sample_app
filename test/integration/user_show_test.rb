require 'test_helper'

class UserShowTest < ActionDispatch::IntegrationTest
  
  def setup
    @inactive_user = users(:inactive)
    @activated_user = users(:archer)
  end
  
  test "should redirect when user not activated" do
    get user_path(@inactive_user)
    # <------------------------------------------------------------------------>
    # Asserts that the response is one of the following types:
    #
    # :success - Status code was 200
    # :redirect - Status code was in the 300-399 range
    # :missing - Status code was 404
    # :error - Status code was in the 500-599 range
    # <------------------------------------------------------------------------>
    # // Refer API dock for more information on assert_response.
    assert_response :redirect
    assert_redirected_to root_url
  end
  
  test "should display user when activated" do
    get user_path(@activated_user)
    assert_response :success
    assert_template 'users/show'
  end
end
