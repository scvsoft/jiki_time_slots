class SlotsController < ApplicationController
  def index

    # TODO: use defaults or specified
    start_time = (params[:start_time] && Time.parse(params[:start_time])) || Time.now
    end_time = (params[:end_time] && Time.parse(params[:end_time])) || start_time + 2.hour
    duration = (params[:duration] && params[:duration].to_i.hours) || 1.hour

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
