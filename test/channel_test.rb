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
      future { Woven.sleep(0.5); c.send(1) }
      future { Woven.sleep(0.25); c.send(2) }
      
      loop do
        Woven.sleep(1)
        if c.size == 2
          future { value = c.receive }
          break
        end
      end
    end

    assert_equal 2, value
  end

  it "should perfor" do
    c = Channel.new
    value = nil

    Woven.run do
      value = Woven::Future.select {
        future { Woven.sleep(0.25); c.send "ello" }
        future { Woven.sleep(0.1); c.send "there" }
        future { Woven.sleep(0.50); c.send "Woven" }

        Woven.sleep(1)
        c.receive
      }
    end

    assert_equal "there", value
  end
end
