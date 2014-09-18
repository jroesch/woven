describe "A Future" do
  failed_future = nil 

  it "should return a Future with an exception" do
    Woven.run do
      failed_future = Woven::Promise.failed(FailedWithError.new("yolo")) 
    end

    assert_raises FailedWithError do
      puts failed_future.value
    end
  end

  it "should run and complete" do
    f = future { 1 }
    f.value.must_equal(1)
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
    two = nil
    Woven.run do
      one = future { "hello" }
      two = one + ", world!"
    end

    assert_equal "hello, world!", two.value
  end

  it "should add two futures together" do
    three = nil
    Woven.run do
      one = future { 1 }
      two = future { 2 }
      three = one + two
    end

    assert_equal 3, three.value
  end

  it "should multiply the future" do
    two = nil
    Woven.run do
      one = future { 1 }
      two = one * 2
    end

    assert_equal 2, two.value
  end

  it "should create futures and execute them out of order" do
    ordering = []

    # Set them up to execute in reverse order
    Woven.run do
      one = future do
        Woven.sleep(0.5)
        ordering << 1
      end

      two = future do
        Woven.sleep(0.25)
        ordering << 2
      end

      three = future do
        Woven.sleep(0.75)
        ordering << 3
      end

      # Execute them in order, if we aren't using fibers each being evaluated in order will cause them to sequentally evaluate with the sleeps
      3.times do
        Woven.sleep(1)

        break if ordering.length == 3
      end
    end

    assert_equal ordering, [2, 1, 3]
  end

  it "should sequence Futures" do
    list_of_futures = []
    future_list = []
    Woven.run do
      list_of_futures << future { 1 }
      list_of_futures << future { 2 }
      list_of_futures << future { 3 }

      future_list = Woven::Future.sequence(list_of_futures)
    end

    assert_equal Woven::Future, future_list.class
    assert_equal [1,2,3], future_list.value
  end

  it "should asynchronously set the status" do
    @status = nil
    
    Woven.run do
      http_request = future do 
        @status = :Running
        stub_request(:any, "http://google.com")
        EventMachine::HttpRequest.new("http://google.com").get
        @status = :Complete
      end

      assert_equal :Running, @status
      Woven.sleep(1)
    end

    assert_equal :Complete, @status
  end
end
