require 'test_helper'

class ArtworksControllerTest < ActionDispatch::IntegrationTest
  test "should get callback" do
    get artworks_callback_url
    assert_response :success
  end

end
