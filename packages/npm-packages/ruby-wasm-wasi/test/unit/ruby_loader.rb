require "test-unit"
require "js/ruby_loader"

class TestRubyLoader < Test::Unit::TestCase
  def test_load
    loader = JS::RubyLoader.new
    loaded_feature = "/virtual/ruby_loader_test.rb"

    assert_false loader.loaded?(loaded_feature)
    assert_true loader.load(
      "$ruby_loader_test_filename = __FILE__",
      loaded_feature,
      loaded_feature
    )
    assert_equal loaded_feature, $ruby_loader_test_filename
    assert_true loader.loaded?(loaded_feature)
  ensure
    $ruby_loader_test_filename = nil
    $LOADED_FEATURES.delete(loaded_feature)
  end
end
