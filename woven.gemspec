require File.expand_path('../lib/woven/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'woven'
  gem.date        = '2014-09-02'
  gem.summary     = %q{Provide a better interface for using EventMachine and deferrables.}
  gem.description = %q{Woven is a clean interface to using EventMachine and deferrables for asynchronous and parallel programming. The
                       interface is based off of Scala's Futures and Promises.}
  gem.authors     = ['Jared Roesch', 'Pete Cruz']
  gem.email       = ['roeschinc@gmail.com', 'iPetesta@gmail.com']
  gem.homepage    = 'https://github.com/jroesch/debugging-tools'
  gem.license     = 'MIT'
  gem.files       = Dir['lib/**/*']
  gem.version     = Woven::VERSION

  gem.add_dependency 'em-synchrony'
  gem.add_dependency 'fiber'
end
