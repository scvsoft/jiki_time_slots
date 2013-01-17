require 'spec_helper'

describe Calendar do
  before :each do
    mock_google_api
  end

  let(:monkey) do
    MonkeyCredential.new(
      token: "some token",
      refresh_token: "some refresh token"
    )
  end

  describe "#events" do
    context "with monkey with events" do
      it "returns the events for that time frame for the monkey" do
        start_time = Time.new(2013, 1, 14)
        end_time = start_time + 3.hours

        expected_events = some_events(start_time, end_time)
        @client.stub(:execute) do |opts|
          opts[:parameters]["timeMin"].should == start_time.to_datetime.rfc3339
          opts[:parameters]["timeMax"].should == end_time.to_datetime.rfc3339

          mock_result_from_api(expected_events)
        end

        events = Calendar.new(monkey).events(start_time, end_time)

        events.should == expected_events
      end
    end

    context "with expired token" do
      it "updates the monkey token after calling the api" do
        start_time = Time.new(2013, 1, 14)
        end_time = start_time + 3.hours

        @client.stub(:execute) do |opts|
          @client.authorization.access_token = "a new token"
          mock_result_from_api([])
        end

        monkey.should_receive(:update_attributes).with(token: "a new token")

        Calendar.new(monkey).events(start_time, end_time)
      end
    end
  end

  def some_events(start_time, end_time)
    [
      Calendar::Event.new("An event", start_time, end_time),
      Calendar::Event.new("Another event", start_time, end_time),
      Calendar::Event.new("Yet another event", start_time, end_time)
    ]
  end

  def mock_google_api
    @client = client = double(Google::APIClient)
    Google::APIClient.stub(:new).and_return(client)

    authorization = OpenStruct.new

    client.stub(:authorization).and_return(authorization)

    @service = service = double("Service")
    events = double("events")
    events.stub(:list).and_return(double("list"))
    service.stub(:events).and_return(events)
    client.stub(:discovered_api).with('calendar', 'v3').and_return(service)
  end

  def mock_result_from_api(events)
    result = OpenStruct.new
    result.data = OpenStruct.new
    result.data.items = events.map do |event|
      OpenStruct.new({
        summary: event.name,
        start: OpenStruct.new(date: event.start.to_s),
        end: OpenStruct.new(date: event.end.to_s)
      })
    end

    result
  end
end