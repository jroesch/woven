require_relative '../awaitable/awaitable'

module Woven
  class Future < Awaitable
    def method_missing(method_name, *args, &block)
      if self.is_a?(Woven::Future) && !self.respond_to?(method_name)
        future do
          unpacked_args = args.map do |arg|
            if arg.is_a?(Woven::Future)
              arg.value
            else
              arg
            end
          end

          self.value.send(method_name, *unpacked_args, &block)
        end

      else
        raise NoMethodError, "Undefined method #{meth} for #{self}"
      end
    end
  end
end
