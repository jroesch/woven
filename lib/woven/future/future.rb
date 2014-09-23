require 'em-synchrony'
require 'fiber'
require_relative '../awaitable'

module Woven
  class Future < Awaitable
    @@current_fiber = nil

    def self.current_fiber
      @@current_fiber
    end

    def self.current_fiber=(current_fiber)
      @@current_fiber = current_fiber
    end

    class << self
      def sequence(*args) 
        future { args.map { |arg| arg.value } }
      end
      
      # Look at select in Go?
      def select(futures)
        future do
          # Create a promise and only write
          chan = Channel.new
        
          futures.each do |future|
            future.map_f { |v| chan.send(v) }
          end
          
          chan.receive
        end
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
          @@current_fiber.resume(result)
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
