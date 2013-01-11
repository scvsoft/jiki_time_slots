class SlotsController < ApplicationController
	def index
		# @slots = { monkeys: [], slots: [], events: [] }
		calendar = Calendar.new

		# TODO: use defaults or specified
		start_time = Time.now
		end_time = start_time + (60*60)
		duration = 1

		slots = SlotRange.new start_time, end_time, duration

		MonkeyCredential.all.each do |monkey|
			calendar.configure(monkey.token)
			# @slots[:events] = 
			events = calendar.list_events(start_time, end_time)
			slots.slot monkey, events
		end

		respond_to do |format|
			format.json { render :json => slots }
		end
	end
end
