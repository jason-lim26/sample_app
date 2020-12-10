require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup 
    ActionMailer::Base.deliveries.clear
  end
  
  test "invalid signup information" do 
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    # From: https://gist.github.com/getadeo/c1be5c5d7bd47a9860ec6d9fcdd538af
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'
    assert_select "li", "Name can't be blank"
    assert_select "li", "Email is invalid"
    assert_select "li", "Password confirmation doesn't match Password"
    min_validation = User.validators_on(:password).find do |v|
      v.options.key?(:minimum)
    end
    min_length = min_validation.options[:minimum]
    assert_select "li", "Password is too short (minimum is #{min_length} characters)"
  end
  
  # Initially this was valid information test only, account activation was added 
  # in Chapter 11.
  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    # Account activation test:
    
    # This code verifies that exactly 1 message was delivered. Because the
    # 'deliveries' array is global, we have toi reset it in the 'setup' method 
    # to prevent our code from breaking if any other tests deliver email.
    assert_equal 1, ActionMailer::Base.deliveries.size
    # 'assigns' let us access instance variables in the corresponding action.
    # For example, the Users controller’s create action defines an @user 
    # variable, so we can access it in the test using 'assigns(:user)'.
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token.
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email.
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    # assert_not flash.empty?
    assert is_logged_in?
  end
end
