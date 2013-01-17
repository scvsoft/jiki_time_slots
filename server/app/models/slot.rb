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

  def check_availability(monkey, events)
    if events.empty?
      @monkeys << monkey.email
    else
      events.each do |event|
        if overlaps_with?(event)
          @busy << monkey.email
        else
          @monkeys << monkey.email
        end
      end
    end
  end

  private

  def overlaps_with?(event)
    end_time = @start_time + @duration

    event.end != @start_time &&
      event.start != end_time &&
      (start_time.to_i..end_time.to_i)
        .overlaps?(event.start.to_i..event.end.to_i)

  end
end
