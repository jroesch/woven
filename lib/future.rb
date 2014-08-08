require 'em-synchrony'
require "em-synchrony/em-http"
require 'eventmachine'
require 'fiber'
require 'pry'

$LOAD_PATH.unshift('lib')

# Logic for blocking and durations over Deferrables

class Awaitable
  include EventMachine::Deferrable

  def initialize(deferrable)
    @deferrable = deferrable
  end
  
  # interface for awaiting defferables
  # simply pass a deferrable and when it is done we will resume the current thread and pass back the result
  def block_on_value
    f = Fiber.current

    @deferrable.callback { |result| f.resume(result) }
    @deferrable.errback { |error| p "Received error: #{error}!"; f.resume } # issues with errback? look at exp.
    binding.pry
    Fiber.yield
  end
end

EM.synchrony { await = Awaitable.new(EventMachine::HttpRequest.new("http://go---ogle.com").aget); await.block_on_value; EM.stop }

class Promise
  attr_reader :future
  
  def initialize
    @future  = Future.new(self)
    @result  = nil
    @yielded = false
  end

  class << self
    def fail(error)
      if error.is_a?(StandardError)
        raise "Not Yet!"
      else
        raise TypeError, "A Promise must fail with a subtype of StandardError"
      end
    end

    def succeed(value)
      raise "not yet implemented"
    end
  end

  def fulfill(result)
    @result = result 
  end

  def success?
    !failed?
  end

  def failed?
    @result.nil?
  end

  def on_complete
    yield @result
  end

  def value
    until fulfilled?
      Fiber.yield
    end
    
    case @result
    when StandardError
      raise @result
    else
      @result
    end
  end

  private
  # I think this is the MVP but we should replace this with an Executor/ExecutionContext like abstraction
  # for scheduling work across threads and fibers, more thought is needed here
  
  # def check_progress(original_fiber)
  #  if fulfillled? && original_fiber.alive? && original_fiber != Fiber.current && @yielded
  #    original_fiber.resume
  #  end
  # end

  def fulfilled?
    !@result.nil?
  end

end

module Scheduler
  class FIFO
  end
end

# I think this may be wrong headed, need to sleep on it
class ExecutionContext
  def initialize(root_fiber, backing, scheduling)
    @root_fiber = root_fiber
    
    case backing
    when :fibers
      use_scheduling!(scheduling)
    else
      raise ArgumentError, "unsupported execution model: #{backing}"
    end
  end
  
  def execute(task)
    @queue.empty?
    resume_scheduler
  end
  
  def run
    while !@queue.empty?
      task = @queue.pop
      task.transfer
      if task.alive?
        @queue << task
      end
    end
  end

  def use_scheduling!(scheduling)
    @scheduler = 
      case scheduling
      when :fifo
      else
        raise ArgumentError, "unsupported scheduler"
      end
  end

  private

  def resume_scheduler
    Fiber.current != @root_fiber
    @root_fiber.transfer
  end

end

class Future < Awaitable
  class << self
    def run
      @result = nil
      EventMachine.synchrony do
        @result = yield
      end
      @result
    end

    def all(*args)
      future { args.map { |arg| arg.value } }
    end
  end

  def initialize(promise, &body)
    @promise = promise
    @body = body
  end

  # Kick off Fiber then return a reference to itself?
  def run
    promise = Promise.new 
    if @body 
      Fiber.new do
        begin
          result = @body.call
          promise.fulfill(result)
        rescue StandardError => e
          promise.fulfill(e)
        end 
      end.resume
    end 

    promise.future
  end

  def value
    @promise.value
  end

end

def future(&body)
  Future.new(Promise.new, &body).run
end
