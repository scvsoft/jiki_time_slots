class SlotsController < ApplicationController
  def index

    # TODO: use defaults or specified
    start_time = Time.now
    end_time = start_time + 3.hour
    duration = 1.hour

    slots = SlotRange.new(start_time, end_time, duration)

    MonkeyCredential.all.each do |monkey|
      slots.slot(monkey)
    end

    context = {
      start_time: start_time,
      end_time: end_time,
      duration: duration,
      slots: slots
    }

    respond_to do |format|
      format.json { render :json => context }
    end
  end
end
