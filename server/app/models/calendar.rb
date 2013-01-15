class Calendar

  def initialize(token)
    @token = token
  end

  def list_events(start_time, end_time)
    prepare
    result = call(api_method: @service.events.list,
      parameters: {
        "calendarId" => "primary",
        "timeMin" => start_time.to_datetime.rfc3339,
        "timeMax" => end_time.to_datetime.rfc3339 })

    result.data.items.map do |item|
      {
        name: item["summary"],
        start: to_time(item.start.date) || item.start.date_time,
        end: to_time(item.end.date) || item.end.date_time,
      }
    end
  end

private

  def call(parameters)
    @client.execute(parameters)
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
