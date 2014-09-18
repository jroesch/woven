require 'eventmachine'
require 'em-synchrony'
require "em-synchrony/em-http"
require 'fiber'
require 'pry'
require_relative './woven/awaitable'
require_relative './woven/channel'
require_relative './woven/future/future'
require_relative './woven/future/syntax'
require_relative './woven/promise'

$LOAD_PATH.unshift('lib')

module Woven
  extend self

  def run(&body)
    result = nil
    EM.synchrony do
      result = body.call
      EM.stop
    end
    result
  end

  def sleep(time)
    EM::Synchrony.sleep(time)
  end
end

def future(&body)
  Woven::Future.new(Woven::Promise.new, &body).run
end
