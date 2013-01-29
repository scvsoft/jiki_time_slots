class SlotsController < ApplicationController
  def index

    start_time = (params[:start_time] && DateTime.parse(params[:start_time])) || DateTime.now.change(min: 0)
    end_time = (params[:end_time] && DateTime.parse(params[:end_time])) || start_time + 2.hour
    duration = (params[:duration] && params[:duration].to_i.hours) || 1.hour

    slots = SlotRange.new(start_time, end_time, duration)

    MonkeyCredential.all.each do |monkey|
      slots.slot(monkey)
    end

    respond_to do |format|
      format.json { render :json => slots }
    end
  end

end
