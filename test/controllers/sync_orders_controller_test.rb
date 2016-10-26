require 'test_helper'

class SyncOrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get sync_orders_create_url
    assert_response :success
  end

end
