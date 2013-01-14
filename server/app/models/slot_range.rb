class SlotRange

  attr_accessor :slots

  # create a set of Slots for the specified time window and duration
  def initialize(start_time, end_time, duration)
    # TODO: validate end_time > start_time?
    # TODO: what about duration < 1 hour?
    slots_starts = Slot.analyze(start_time, end_time, duration)
    @slots = {}

    slots_starts.each do |slot_start_time|
      @slots[slot_start_time] = Slot.new(start_time: slot_start_time, duration: duration)
    end
  end

  def slot(monkey, events)
    if events.empty?
      @slots.each do |start_time, slot|
        slot.add_monkey monkey.email
      end          
    else
      events.each do |event|
        # check if it's in any of the slots
        @slots.each do |start_time, slot|
          slot.add_busy_monkey monkey.email if slot.in_range? event.start 
        end
      end
    end
  end
end
