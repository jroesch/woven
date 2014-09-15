require_relative '../lib/woven'
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

# describe "ExecutionContext" do
#   it "should execute a task" do
#     skip "skip"
#     @ec.execute()
#   end
# end

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

  it "slice from a list with map_f" do
    two = []
    Future.run do
      one = future do
        [1,2,3,4,5] 
      end

      two = one.f_map { |n| n.slice(0,2) }
    end

    assert_equal [1,2], two
  end

  it "actually map" do
    two = []
    Future.run do
      one = future do
        [1,2,3,4,5]
      end
      
      two = one.map { |n| n + 1 }
    end

    assert_equal [2,3,4,5,6], two.value
  end

  it "should create be able to create and user a future via" do
    ordering = []
    # set them up to execute in reverse order

    Future.run do
      
      one = future do
        EM::Synchrony.sleep(0.5)
        ordering << 1
      end

      two = future do
        EM::Synchrony.sleep(0.25)
        ordering << 2
      end

      three = future do
        EM::Synchrony.sleep(0.75)
        ordering << 3
      end

      # execute them in order, if we aren't using fibers each being evaluated in order will cause them to sequentially evaluate with the sleeps
      3.times do
        EM::Synchrony.sleep(1)

        break if ordering.length == 3
      end
    end

    assert_equal ordering, [2, 1, 3]
  end
end
