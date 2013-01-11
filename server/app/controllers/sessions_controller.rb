require 'date'

# REF http://blog.baugues.com/google-calendar-api-oauth2-and-ruby-on-rails
class SessionsController < ApplicationController
  def create
    #What data comes back from OmniAuth?
    @auth = request.env["omniauth.auth"]
    #Use the token from the data to request a list of calendars
    @token = @auth["credentials"]["token"]
    email = @auth["uid"]
    ape = MonkeyCredential.where(email: email).first

    if ape
      ape.update_attributes(email: email, token: @token)
    else
      MonkeyCredential.create(email: email, token: @token)
    end

    # client = Google::APIClient.new
    # client.authorization.access_token = @token
    # service = client.discovered_api('calendar', 'v3')
    # @result = client.execute(
    #   :api_method => service.events.list,
    #   :parameters => {
    #     "calendarId" => "primary",
    #     "timeMin" => DateTime.now.rfc3339
    #   })

    # # range.overlaps?(other_range)

    # @events = @result.data.items.map do |item|
    #   {
    #     name: item["summary"],
    #     start: to_time(item.start.date) || item.start.date_time,
    #     end: to_time(item.end.date) || item.end.date_time,
    #   }
    # end
  end

  private

  def to_time(date_or_nil)
    Time.parse(date_or_nil) if date_or_nil
  end
end
