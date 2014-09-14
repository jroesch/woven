class Process
  def halt?
    case self
    when Halt
      true
    else
      false
    end
  end
end

class Emit < Process
  attr_reader :head, :tail
  def initialize(head, tail); end
end

class Await < Process
  def initialize(receiver); end
end

class Halt < Process; end
