class SlotRange

  attr_accessor :slots

  # create a set of Slots for the specified time window and duration
  def initialize(start_time, end_time, duration)
    # TODO: validate end_time > start_time?
    # TODO: what about duration < 1 hour?
    slots_starts = group_slots(start_time, end_time, duration)

    @slots = slots_starts.map do |slot_start_time|
      Slot.new(start_time: slot_start_time, duration: duration)
    end

  end

  def slot(monkey, events)
    if events.empty?
      @slots.each do |slot|
        slot.add_monkey(monkey.email)
      end          
    else
      events.each do |event|
        # check if it's in any of the slots
        @slots.select { |slot| slot.in_range?(event[:start]) }.each do |slot|
          slot.add_busy_monkey(monkey.email)
        end
      end
    end
  end

  private

  # based on a start time, an end time and a duration, detect
  # when a new slot begins, and return the start times of every slot
  def group_slots(start_time, end_time, duration)
    period = end_time - start_time
    time = start_time    
    slots_starts = []

    from = start_time.to_i
    to = (end_time - duration).to_i

    (from..to).step(30.minutes).map { |timestamp| Time.at(timestamp) }
  end

end
