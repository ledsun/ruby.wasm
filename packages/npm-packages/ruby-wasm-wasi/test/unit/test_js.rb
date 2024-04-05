require "test-unit"
require "js"

class JS::TestJS < Test::Unit::TestCase
  def test_is_a?
    # A ruby object always returns false
    assert_false JS.is_a?(1, Integer)
    assert_false JS.is_a?("x", String)
    # A js object is not an instance of itself
    assert_false JS.is_a?(JS.global, JS.global)
    # globalThis is an instance of Object
    assert_true JS.is_a?(JS.global, JS.global[:Object])
  end

  def test_eval
    JS.eval("var x = 42;")
    # Variable scope is isolated in each JS.eval
    assert_equal "not defined", JS.eval(<<~JS).to_s
      try {
        return x;
      } catch {
        return "not defined";
      }
    JS
  end

  def test_try_convert
    assert_nil JS.try_convert(Object.new)
  end

  def test_constasts
    assert_equal "null", JS::Null.to_s
    assert_equal "undefined", JS::Undefined.to_s
    assert_equal "true", JS::True.to_s
    assert_equal "false", JS::False.to_s
  end

  def test_falsy?
    assert_true JS.falsy?(JS::False)
    assert_true JS.falsy?(JS::Zero)
    assert_true JS.falsy?(JS::NinusZero)
    assert_true JS.falsy?(JS::BingIntZero)
    assert_true JS.falsy?(JS::EmptyString)
    assert_true JS.falsy?(JS::Null)
    assert_true JS.falsy?(JS::Undefined)
    assert_true JS.falsy?(JS::Nan)
    assert_false JS.falsy?({}.to_js)
    assert_false JS.falsy?([].to_js)
  end

  def test_truthy?
    assert_true JS.truthy?(JS::True)
    assert_true JS.truthy?({}.to_js)
    assert_true JS.truthy?([].to_js)
    assert_true JS.truthy?(42.to_js)
    assert_true JS.truthy?("0".to_js)
    assert_true JS.truthy?("false".to_js)
    assert_true JS.truthy?(JS.eval("return new Date()"))
    assert_true JS.truthy?(-42.to_js)
    assert_true JS.truthy?(JS.eval("return 12n"))
    assert_true JS.truthy?(JS.eval("return 3.14"))
    assert_true JS.truthy?(JS.eval("return -3.14"))
    assert_true JS.truthy?(JS.eval("return Infinity"))
    assert_true JS.truthy?(JS.eval("return -Infinity"))
    assert_false JS.truthy?(JS::False)
    assert_false JS.truthy?(JS::Zero)
    assert_false JS.truthy?(JS::NinusZero)
    assert_false JS.truthy?(JS::BingIntZero)
    assert_false JS.truthy?(JS::EmptyString)
    assert_false JS.truthy?(JS::Null)
    assert_false JS.truthy?(JS::Undefined)
    assert_false JS.truthy?(JS::Nan)
  end
end
