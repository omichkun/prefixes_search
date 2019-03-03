require 'test_helper'

class MainControllerTest < ActionDispatch::IntegrationTest
  test "should get main" do
    get root_url
    assert_response :success
  end

  test  "should post search" do

  end

end
