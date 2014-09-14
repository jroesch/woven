# @author Jared Roesch

# An interface for the lazily streaming of values in Ruby. This a composable version of the ideas from
# Enumerable.
#

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/pride'

# Use Enumerator interface to drive the Streams
def enum(&blk)
  Class.new do
    include Enumerable

    define_method(:each, &blk)
  end
end

# Play with these ideas more later, we probably just want to build a network that can be treated as a enumerable
module Stream  
  attr_accessor :halted
    
  # This is the interface of the class.
  def emit
    raise "The default implementation of Stream#next does nothing please implement the next method in order to use this mixin."
  end
  
  def await
  end

  def halt!
  end

  def each
    Enumerable.new
  end
end

module Pipe; end
module Source; end
module Sink; end

def Stream(source)
  case source
  when Array
    ArraySource.new(source)
  when Hash
    HashSource.new(source)
  when String
    StringSource.new(source)
  else
    raise TypeError, "can not create Stream from #{source.class}"
  end
end

class ArraySource
  include Stream

  def initialize(array)
  end
end

class ArraySink
  include Stream

  def initialize(array)
  end
end

class Generator
  include Stream

  def initialize(&block)
    @block = block
  end

  def emit
    instance_eval(&@block)
  end
end

describe "The Stream class" do
  it "should implement a smart constructor" do
    assert respond_to? :Stream
  end

  it "smart constructor should accept an Array" do
    array_stream = Stream([1,2,3,4,5,6])
    array_stream.filter
  end
    
  it "smart constructor should accept a Hash"
  it "smart constructor should accept a String"
  it "smart constructor should raise an TypeError otherwise"
end

