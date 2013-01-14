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
    end_time = @start_time + @duration * 60 * 60
    time.between? @start_time, end_time
  end

  # based on a start time, an end time and a duration, detect
  # when a new slot begins, and return the start times of every slot
  def Slot.analyze(start_time, end_time, duration)
    period = end_time - start_time    # in seconds?
    time = start_time
    number = ((period/60/60) / duration).floor
    slots_starts = []

    (1..number).each do |num|
      slots_starts << time
      time += duration
    end

    slots_starts
  end
end
