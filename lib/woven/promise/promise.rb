require_relative '../future/future'

module Woven
  class Promise
    class << self
      def fail(error)
        if error.is_a?(StandardError)
          raise "Not Yet!"
        else
          raise TypeError, "A Promise must fail with a subtype of StandardError"
        end
      end

      def succeed(value)
        raise "Not yet implemented"
      end
    end

    attr_reader :future

    def initialize
      @future  = Woven::Future.new(self)
      @result  = nil
      @yielded = false
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
end
