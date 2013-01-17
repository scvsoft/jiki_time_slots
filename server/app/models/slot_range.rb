class SlotRange

  attr_accessor :slots

  # create a set of Slots for the specified time window and duration
  def initialize(start_time, end_time, duration)

    @start_time = start_time
    @end_time = end_time

    # TODO: validate end_time > start_time?
    # TODO: what about duration < 1 hour?
    slots_starts = group_slots(start_time, end_time, duration)

    @slots = slots_starts.map do |slot_start_time|
      Slot.new(start_time: slot_start_time, duration: duration)
    end

  end

  def slot(monkey)

    events = monkey.calendar.events(@start_time, @end_time)
    @slots.each do |slot|
      slot.check_availability(monkey, events)
    end

  end

  private

  # based on a start time, an end time and a duration, detect
  # when a new slot begins, considering 30-minutes steps,
  # and return the start times of every slot
  def group_slots(start_time, end_time, duration)

    raise ArgumentError if !(start_time and end_time and duration)

    from = start_time.to_i
    to = (end_time - duration).to_i

    (from..to).step(30.minutes).map { |timestamp| Time.at(timestamp) }
  end

end
