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
  failed_future = nil 

  it "should return a Future with an exception" do
    Woven.run do
      failed_future = Woven::Promise.failed(FailedWithError.new("yolo")) 
    end

    binding.pry
    assert_raises FailedWithError do
      puts failed_future.value
    end
  end

  it "should run and complete" do
    f = future { 1 }

    f.value.must_equal(1)
  end
  
  it "#all method should sequence a set of futures" do
    Woven::Future.all(future { 1 }, future { 2 }, future { 3 }).value.must_equal [1,2,3]
  end

  it "should slice from a list with map_f" do
    two = []
    Woven.run do
      one = future { [1,2,3,4,5] }

      two = one.f_map { |n| n.slice(0,2) }
    end

    assert_equal [1,2], two.value
  end

  it "should map over a list" do
    two = []
    Woven.run do
      one = future { [1,2,3,4,5] }
      
      two = one.map { |n| n + 1 }
    end

    assert_equal [2,3,4,5,6], two.value
  end

  it "should concatenate a string" do
    two = ""
    Woven.run do
      one = future { "hello" }

      two = one + ", world!"
    end

    assert_equal "hello, world!", two.value
  end

  it "should add two futures together" do
    three = 0
    Woven.run do
      one = future { 1 }
      two = future { 2 }
      three = one + two
    end

    assert_equal 3, three.value
  end

  it "should multiply the future" do
    two = 0
    Woven.run do
      one = future { 1 }
      two = one * 2
    end

    assert_equal 2, two.value
  end

  it "should create futures and execute them out of order" do
    ordering = []

    # set them up to execute in reverse order
    Woven.run do
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

describe "A Channel" do
  it "should have a message on the queue" do
    c = Channel.new
    value = []

    Woven.run do
      future { c.send(1); c.send(2); c.send(3) }  
      future { value << c.receive; value << c.receive; value << c.receive }
    end

    assert_equal [1,2,3], value
    assert_equal true, c.empty?
  end

  it "should enqueue messages out of order" do
    c = Channel.new
    value = nil

    Woven.run do 
      future { EM::Synchrony.sleep(0.5); c.send(1) }
      future { EM::Synchrony.sleep(0.25); c.send(2) }
      
      loop do
        EM::Synchrony.sleep(1)
        if c.size == 2
          future { value = c.receive }
          break
        end
      end
    end

    assert_equal 2, value
  end
end
