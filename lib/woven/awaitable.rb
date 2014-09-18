require 'eventmachine'

module Woven
  class Awaitable
    include EventMachine::Deferrable

    def initialize(deferrable)
      @deferrable = deferrable
    end
    
    # interface for awaiting defferables

    def block_on_value
      f = Fiber.current

      @deferrable.callback { |result| f.resume(result) }
      @deferrable.errback  { |error| p "Received error: #{error}!"; f.resume }
      Fiber.yield
    end
  end
end
