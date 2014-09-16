require 'eventmachine'
require 'em-synchrony'
require 'fiber'
require "em-synchrony/em-http"
require 'pry'
require_relative './woven/awaitable/awaitable'
require_relative './woven/future/future'
require_relative './woven/future/syntax'
require_relative './woven/promise/promise'



$LOAD_PATH.unshift('lib')

module Woven; end

def future(&body)
  Woven::Future.new(Woven::Promise.new, &body).run
end
