require 'em-synchrony'
require 'fiber'

class Result
  def success?
    !self.failed?
  end

  def failure?
    !self.success?
  end
end

class Success < Result
  def success?
    true
  end
end

class Failure < Result
  def failure?
    true
  end
end

class Awaitable; end

class Promise
  attr_reader :future
  
  def initialize
    @result = nil
  end

  def self.fail(error)
    if error.is_a?(StandardError)
      raise "Not Yet!"
    else
      raise TypeError, "A Promise must fail with a subtype of StandardError"
    end
  end

  def self.succeed(value)
    raise "not yet implemented"
  end

  def complete(result)
  end

  def succeed_with(value)
    complete(Success.new(cause))
  end

  def fail_with(cause)
    complete(Failure.new(cause))
  end

  def succeed?
  end

  def failed?
  end

  def on_complete
    yield @result
  end
  
private
  # I think this is the MVP but we should replace this with an Executor/ExecutionContext like abstraction
  # for scheduling work across threads and fibers, more thought is needed here
  
  def check_progress(original_fiber)
    if finished? && original_fiber.alive? && original_fiber != Fiber.current && @yielded
      original_fiber.resume
    end
  end

  def finished?
    !@result.nil?
  end
end

