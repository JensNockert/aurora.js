require 'execjs'
require 'test/unit'

LIB = "#{File.dirname(__FILE__)}/../../lib"

class TestObject < Test::Unit::TestCase
  def test_alloc_init
    assert_equal({}, Context.eval("Aurora.object.alloc()"),                                                 'should be a blank slate after allocation')
    assert_not_nil(  Context.eval("Aurora.object.alloc().init()"),                                          'should not be nil after initialization')
    assert(          Context.eval("Object.getPrototypeOf(Aurora.object.alloc().init()) == Aurora.object"),  'should have Aurora.object as prototype')
    
  end
  
  def test_properties
    src = <<EOF
      var c = Aurora.object, o = Aurora.object.alloc().init(), op = []
      
      for (var p in o) { if (!c[p]) { op.push(p) } }
      
      return op
EOF
    
    assert_equal([], Context.exec(src), 'should not have gained any enumerable properties during initialization')
  end
  
  def test_events
    src = <<EOF
      var o = Aurora.object.alloc().init()
      var r = false
      
      o.addEventListener('test', function () {
        r = true
      })
      
      o.dispatchEvent({ type: 'test' })
      
      return r
EOF
    
    assert(Context.exec(src), 'should call event handler')
    
    src = <<EOF
      var o = Aurora.object.alloc().init()
      var r = false
      
      o.dispatchEvent({ type: 'test' })
      
      return r
EOF
    
    assert(!Context.exec(src), 'should not do anything')
    
    src = <<EOF
      var o = Aurora.object.alloc().init()
      var r = false
      
      var f = function () {
        r = true
      }
      
      o.addEventListener('test', f)
      o.removeEventListener('test', f)
      
      o.dispatchEvent({ type: 'test' })
      
      return r
EOF
    
    assert(!Context.exec(src), 'should not call event handler')
  end
end