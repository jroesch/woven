require './future'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/pride'

describe "A Promise" do
  it "should be completed when created using Promise#succeed" do; end

  it "should be failed when created using Promise#fail" do; end
  
  it "should provide access to a future which it completes" do
    promise = Promise.succeed(10)
    promise.future
    raise "Not sure what comes next"
  end
end
