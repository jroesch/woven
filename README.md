# Woven

## What is Woven?

Woven is built on top of `em_synchrony` in order to take advantage of its event-driven I/O and concurrency model.
It provides a clean interface for using Promises's and Future's similar to Scala and JavaScript in an asychronous style.

Futures are composable so new futures can created in an asynchronous manner.

## An example of using Woven
Here is an example of how to use futures in Woven.
```
f3 = ""
Woven::Future.run do
  f1 = future { "Hello, " }
  f2 = future { "world!" }

  f3 = f1 + f2
end
```

To get access to the value within the future.
```
f3.value => "Hello, world!"
```
