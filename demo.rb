require 'em-synchrony'
require 'em-synchrony/em-http'
require 'em-synchrony/mysql2'
require 'em-synchrony/activerecord'
require_relative './lib/woven'

future_list = []
queries = []
value = nil
value2 = nil

Woven.run do
  Woven::Future.current_fiber = Fiber.current
  #db = EventMachine::Synchrony::ConnectionPool.new(size: 2) do
  #  Mysql2::EM::Client.new(host: "localhost")
  #end
  
  page1 = future { EventMachine::HttpRequest.new("http://google.com").get }
  #page1 = future { EventMachine::HttpRequest.new("http://google.com").get; }
  #page1 = future { 1 }
  page2 = future { EventMachine::HttpRequest.new("http://twitter.com").get }
  #page3 = future { EventMachine::HttpRequest.new("http://www.facebook.com").get }
  value = page1.value
  binding.pry
  value2 = page2.value
  #val = Woven::Future.select(future_list)
  
  #value = page1.value

  puts "inside demo"

  #future_list = Woven::Future.sequence(page1)
  #future_list = Woven::Future.sequence(page1, page2, page3).value
  
  #queries << future { db.query("select value from future where id = #{1}") }
  #queries << future { db.query("select value from future where id = #{3}") }
  #queries << future { db.query("select value from future where id = #{2}") }
  #Woven::Future.sequence(*queries)
end

puts "here"
puts value.response_header
puts "here"
binding.pry
puts value2.response_header
puts "shit"
#puts future_list.class
#puts future_list.value
#puts future_list.value[0]
#puts future_list.value[1]
#puts future_list.value[2]
