require 'em-synchrony'
require 'em-synchrony/em-http'
require 'em-synchrony/mysql2'
require 'em-synchrony/activerecord'
require 'fiber'

class Scheduler
  def initialize
    @scheduler_fiber = Fiber.current
    @fibers = []
  end
  
  def new_fiber(&block)
    @fibers << ScheduledFiber.new(@scheduler_fiber, &block)
  end

  def run
    puts "In Run"
    next_to_run = @fibers.pop
    if next_to_run && !next_to_run.finished?
      next_to_run.resume
      if next_to_run.finished?
        # @fibers.result
        puts "Fiber finished"
        puts @fibers.to_s
      else
        @fibers << next_to_run
      end
    end
  end
  
  # This is the piece I'm not sure about
  def self.run!(&block)
    scheduler = Scheduler.new
    EM.synchrony do
      EM.add_periodic_timer(5) { scheduler.run }
      block.call(scheduler)
    end
  end
end

class ScheduledFiber
  def initialize(scheduler_fiber, &body)
    @result = nil
    @fiber =  Fiber.new do
      @result = body.call
    end
  end

  def resume
    @fiber.resume
  end

  def ensure_scheduler_resume(result)
    scheduler_fiber.resume(result)
  end

  def finished?
    !@fiber.alive?
  end
end

Scheduler.run! do |scheduler|
  scheduler.new_fiber do
    puts "On fiber 1"
  end

  scheduler.new_fiber do
    result = EventMachine::HttpRequest.new("http://google.com").get
    puts result.response
  end

  puts "At the bottom!"
end
