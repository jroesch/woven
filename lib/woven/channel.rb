require 'thread'

class Channel
  def initialize
    @queue = Queue.new
  end

  def send(value)
    @queue << value
  end

  def receive
    binding.pry
    if @queue.empty?
      Fiber.yield
    else
      @queue.deq
    end
  end

  def empty?
    @queue.empty?
  end

  def size
    @queue.size
  end
end
