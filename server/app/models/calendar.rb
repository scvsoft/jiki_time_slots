class Calendar

  Event = Struct.new(:name, :start, :end)

  def initialize(monkey)
    @monkey = monkey
  end

  def events(start_time, end_time)
    prepare
    result = call(api_method: @service.events.list,
      parameters: {
        "calendarId" => "primary",
        "timeMin" => start_time.to_datetime.rfc3339,
        "timeMax" => end_time.to_datetime.rfc3339 })

    result.data.items.map do |item|
      Event.new(item.summary,
        # Use to_hash["dateTime"] to preserve the time zone and parse it
        # with DateTime instead of Time (which the api client does)
        to_time(item.start.date) || to_time(item.start.to_hash["dateTime"]),
        to_time(item.end.date) || to_time(item.end.to_hash["dateTime"]))
    end
  end

private

  def call(parameters)
    prev_token = @client.authorization.access_token
    response = @client.execute(parameters)
    # @client.execute automatically refreshes the token if it expired
    token = @client.authorization.access_token
    @monkey.update_attributes(token: token) if token != prev_token

    response
  end

  def prepare
    @client = Google::APIClient.new

    @client.authorization.client_id = GoogleCredentials::CLIENT_ID
    @client.authorization.client_secret = GoogleCredentials::CLIENT_SECRET
    @client.authorization.access_token = @monkey.token
    @client.authorization.refresh_token = @monkey.refresh_token

    @service = @client.discovered_api('calendar', 'v3')
  end

  def to_time(date_or_nil)
    DateTime.parse(date_or_nil) if date_or_nil
  end
end
