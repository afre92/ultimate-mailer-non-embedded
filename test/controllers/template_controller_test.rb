require 'test_helper'

class TemplateControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get template_edit_url
    assert_response :success
  end

  test "should get update" do
    get template_update_url
    assert_response :success
  end

end
