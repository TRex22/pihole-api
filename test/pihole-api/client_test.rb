require 'test_helper'

class PiholeApiTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::PiholeApi::VERSION
  end

  def test_that_the_client_has_compatible_api_version
    assert_equal 'v2', PiholeApi::Client.compatible_api_version
  end

  def test_that_the_client_has_api_version
    assert_equal 'v2 2020-10-17', PiholeApi::Client.api_version
  end
end
