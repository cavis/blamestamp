require 'test_helper'

class BlamestampTest < ActiveSupport::TestCase
  test "exists" do
    assert_kind_of Module, Blamestamp, "blamestamp isn't what it seems to be"
  end
end
