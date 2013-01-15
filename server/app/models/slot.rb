# A Slot is a period of time defined by a start time, a duration,
# people being queried and people busy.
class Slot
  attr_accessor :monkeys, :start_time, :duration, :busy

  def initialize(params)
    @monkeys = []
    @start_time = params[:start_time]
    @duration = params[:duration]
    @busy = []
  end

  def add_monkey(monkey)
    @monkeys << monkey
  end

  def add_busy_monkey(monkey)
    @busy << monkey
  end

  def in_range?(time)
    end_time = @start_time + @duration
    time.between?(@start_time, end_time)
  end
end
