# Better interface to deferrables from EM
#
#
class Result; end
class Success < Result; end
class Failure < Result; end

class Awaitable; end

class Promise
  attr_reader :future

  def self.fail(error)
    if error.is_a?(StandardError)
      raise TypeError, "A Promise must fail with a subtype of StandardError"
    else
    end
  end

  def self.succeed(value)
    raise "not yet implemented"
  end

  def complete(result)
  end

  def success(value)
    complete(Success.new(cause))
  end

  def failure(cause)
    complete(Failure.new(cause))
  end

  def on_complete
    yield 1
  end
end


p = Promise.new
p.on_complete do |result|
  case result
  when Success
    result.value
  when Failure
    result.error
  end
end
