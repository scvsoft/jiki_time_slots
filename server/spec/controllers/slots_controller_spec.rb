require 'spec_helper'

describe SlotsController do
  let(:monkeys) do
    [
      MonkeyCredential.new(email: "rhesus@scvsoft.com", token: "token1" ),
      MonkeyCredential.new(email: "chimp@scvsoft.com", token: "token2")
    ].each do |monkey|
      monkey.stub(:calendar).and_return(double(Calendar))
    end
  end

  let(:events) do
    [
      Calendar::Event.new(
        "name",
        time = Time.local(2013,1,1,0,30),
        time + 1.hour)
    ]
  end

  describe "GET #index" do
    context "with no parameters" do
      it "returns JSON slots with default values" do
        MonkeyCredential.stub(:all).and_return(monkeys)
        now = DateTime.now
        DateTime.stub(:now).and_return(now)
        monkeys.each do |ape|
          ape.calendar.stub(:events).and_return(events)
        end
        start_time = DateTime.now.change(min: 0)
        slots = {
          start_time: start_time,
          end_time: (start_time + 2.hours),
          slots: [ {
              monkeys: [monkeys[0].email, monkeys[1].email],
              start_time: start_time,
              duration: 1.hour,
              busy: []
            }, {
              monkeys: [monkeys[0].email, monkeys[1].email],
              start_time: (start_time + 30.minutes),
              duration: 1.hour,
              busy: []
            }, {
              monkeys: [monkeys[0].email, monkeys[1].email],
              start_time: (start_time + 60.minutes),
              duration: 1.hour,
              busy: []
            }
          ]
        }

        get :index, format: :json

        response.body.should == slots.to_json

      end
    end

    context "with defined valid parameters" do
      it "returns JSON slots with specified values" do
        MonkeyCredential.stub(:all).and_return(monkeys)
        start_time = Time.local(2013)
        end_time = (Time.local(2013) + 3.hours)
        duration = "1"
        monkeys.each do |ape|
          ape.calendar.stub(:events).and_return(events)
        end
        slots = {
          start_time: start_time,
          end_time: (start_time + 3.hours),
          slots: [ {
              monkeys: [],
              start_time: start_time,
              duration: 1.hour,
              busy: [monkeys[0].email, monkeys[1].email]
            }, {
              monkeys: [],
              start_time: (start_time + 30.minutes),
              duration: 1.hour,
              busy: [monkeys[0].email, monkeys[1].email]
            }, {
              monkeys: [],
              start_time: (start_time + 60.minutes),
              duration: 1.hour,
              busy: [monkeys[0].email, monkeys[1].email]
            }, {
              monkeys: [monkeys[0].email, monkeys[1].email],
              start_time: (start_time + 90.minutes),
              duration: 1.hour,
              busy: []
            }, {
              monkeys: [monkeys[0].email, monkeys[1].email],
              start_time: (start_time + 120.minutes),
              duration: 1.hour,
              busy: []
            }
          ]
        }

        get :index, format: :json, start_time: start_time.to_s, end_time: end_time.to_s, duration: duration

        response.body.should == slots.to_json
      end
    end

  end

end
