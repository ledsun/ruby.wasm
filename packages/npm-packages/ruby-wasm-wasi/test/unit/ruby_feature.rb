require "test-unit"
require "js/ruby_feature"

class TestRubyFeature < Test::Unit::TestCase
  def test_filename_from
    assert_equal "foo.rb", JS::RubyFeature.filename_from("foo")
    assert_equal "foo.rb", JS::RubyFeature.filename_from("foo.rb")
    assert_equal "foo.rb", JS::RubyFeature.filename_from(:foo)
  end
end
