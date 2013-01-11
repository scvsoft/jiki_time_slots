class SlotsController < ApplicationController
	def index
		calendar = Calendar.new

		MonkeyCredential.all.each do |monkey|
			calendar.configure(monkey.token)
			@slots = calendar.list_from_now_on
		end

		respond_to do |format|
			format.json { render :json => @slots }
		end
	end
end
