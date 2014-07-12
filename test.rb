require 'lib/future'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require 'pry'

describe "A Promise" do
  it "should be completed when created using Promise#succeed" do
    skip "nope" 
  end

  it "should be failed when created using Promise#fail" do
    skip "not yet" 
  end
  
  it "should provide access to a future which it completes" do
    # promise = Promise.succeed(10)
    # promise.future
    skip "Not sure what comes next"
  end
end

describe "ExecutionContext" do
  setup do
    @ec = ExecutionContext.new(:fibers, :fifo)
  end

  teardown do
    @ec.clear!
  end

  it "should execute a task" do
    @ec.execute()
  end
end

describe "A Future" do
  it "should run and complete" do
    f = future do
      1
    end

    f.value.must_equal(1)
  end
  

  it "#all method should sequence a set of futures" do
    Future.all(future { 1 }, future { 2 }, future { 3 }).value.must_equal [1,2,3]
  end

  it "should create be able to create and user a future via `future`" do
    skip "foo"
    ordering = []
    # set them up to execute in reverse order
    one = future do
      Fiber.yield
      ordering << 1
    end

    two = future do
      Fiber.yield
      ordering << 2
    end

    three = future do
      ordering << 3
    end
    
    while ordering.length < 3; end
    
    # execute them in order, if we aren't using fibers each being evaluated in order will cause them to sequentially evaluate with the sleeps
    ordering.must_equal([3,2,1])
  end
end
