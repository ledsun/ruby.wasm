require "test-unit"
require "js"
require "js/require_local"

class TestPathResolver < Test::Unit::TestCase
  def test_get_location
    path_resolver = JS::RequireLocal::PathResolver.new("/tmp")
    script_location = path_resolver.get_location("foo.rb")
    assert_equal "/tmp/foo.rb", script_location.path
    assert_equal "/tmp/foo.rb", script_location.filename
  end

  def test_get_location_with_relative_path
    path_resolver = JS::RequireLocal::PathResolver.new("/tmp")
    script_location = path_resolver.get_location("./foo.rb")
    assert_equal "/tmp/foo.rb", script_location.path
    assert_equal "/tmp/foo.rb", script_location.filename
  end

  def test_get_location_without_extension
    path_resolver = JS::RequireLocal::PathResolver.new("/tmp")
    script_location = path_resolver.get_location("./foo")
    assert_equal "/tmp/foo.rb", script_location.path
    assert_equal "/tmp/foo.rb", script_location.filename
  end

  def test_get_location_with_backward_relative_path
    path_resolver = JS::RequireLocal::PathResolver.new("/tmp/bar")
    script_location = path_resolver.get_location("../foo.rb")
    assert_equal "/tmp/foo.rb", script_location.path
    assert_equal "/tmp/foo.rb", script_location.filename
  end

  def test_push_and_pop
    path_resolver = JS::RequireLocal::PathResolver.new("/tmp")
    path_resolver.push("/tmp/foo/bar.rb")
    script_location = path_resolver.get_location("./baz.rb")
    assert_equal "/tmp/foo/baz.rb", script_location.path
    path_resolver.pop
    script_location = path_resolver.get_location("./baz.rb")
    assert_equal "/tmp/baz.rb", script_location.path
  end
end
