class Calendar

	def configure(token)
		@token = token
	end

	def list_from_now_on
		prepare
		call(:api_method => @service.events.list,
	      :parameters => {
	        "calendarId" => "primary",
	        "timeMin" => DateTime.now.rfc3339 })
	    @events = @result.data.items.map do |item|
	      {
	        name: item["summary"],
	        start: to_time(item.start.date) || item.start.date_time,
	        end: to_time(item.end.date) || item.end.date_time,
	      }
	    end
	end

private

	def call(parameters)
	    @result = @client.execute(parameters)
	end

	def prepare
		@client = Google::APIClient.new
	    @client.authorization.access_token = @token
	    @service = @client.discovered_api('calendar', 'v3')
	end
	
	def to_time(date_or_nil)
	Time.parse(date_or_nil) if date_or_nil
	end
end
