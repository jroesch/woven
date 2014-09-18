# Woven

## What is Woven?

Woven is built on top of `em_synchrony` in order to take advantage of its event-driven I/O and concurrency model.
It provides a clean interface for using Promises's and Future's similar to Scala and JavaScript in an asychronous style. Go Channels are also implemented on top of `em_synchrony`.

Futures are composable so new futures can created in an asynchronous manner.

### An example of using Woven with Futures
Here is an example of how to use futures in Woven.
```ruby
f3 = nil
Woven.run do
  f1 = future { "Hello, " }
  f2 = future { "world!" }

  f3 = f1 + f2 # You can combine two futures together
end
```

To get access to the value within the future.
```ruby
f3.value => "Hello, world!"
```

### An example of using Woven with Channels
Here is an example of how to use channels in Woven.
```ruby
c = Channel.new
value = nil
Woven.run do
  future { c.send(1) } 
  future { value = c.receive }
end  

puts value => 1
```
