require 'em-synchrony'
require 'fiber'
require_relative '../awaitable'

module Woven
  class Future < Awaitable
    class << self
      def sequence(args) 
        future { args.map { |arg| arg.value } }
      end

      def select(&block)
        block.call
      end
    end

    def initialize(promise, &body)
      @promise = promise
      @body = body
    end

    def on_complete
      raise "Not yet implemented"
    end

    def on_failure
      raise "Not yet implemented"
    end

    def on_success
      raise "Not yet implemented"
    end

    def run
      promise = Woven::Promise.new
      if @body
        Fiber.new do
          result = begin
            @body.call
          rescue StandardError => err
            err
          end
          promise.fulfill(result)
        end.resume
      end

      promise.future
    end

    def value
      @promise.value
    end

    def f_map(&body)
      f = future { body.call(self.value) }
    end
  end
end
