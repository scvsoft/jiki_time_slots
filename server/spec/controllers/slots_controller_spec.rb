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
        MonkeyCredential.stub(:all) { monkeys }
        monkeys.each do |ape|
          ape.calendar.stub(:events).and_return(events)
        end       
        slots = create_slots(
          quantity: 3, 
          start_time: Time.now.to_formatted_s(:db), 
          end_time: (Time.now + 2.hours).to_formatted_s(:db), 
          duration: 1.hour,
          busy: [],
          monkeys: [ [monkeys[0].email, monkeys[1].email] ])
    
        get :index, format: :json
    
        response.body.should == slots.to_json

      end
    end

    context "with defined valid parameters" do
      it "returns JSON slots with specified values", :selected=>true do
        start_time = Time.local(2013).to_formatted_s(:db)
        end_time = (Time.local(2013) + 3.hours).to_formatted_s(:db)
        duration = "1"
        MonkeyCredential.stub(:all) { monkeys }
        monkeys.each do |ape|
          ape.calendar.stub(:events).and_return(events)
        end       
        slots = create_slots(
          quantity: 5, 
          start_time: start_time, 
          end_time: end_time,
          duration: 1.hour,
          busy: [
            [monkeys[0].email, monkeys[1].email], 
            [monkeys[0].email, monkeys[1].email],
            [monkeys[0].email, monkeys[1].email],
            [],
            []],
          monkeys: [
            [],
            [],
            [],
            [monkeys[0].email, monkeys[1].email],
            [monkeys[0].email, monkeys[1].email]
          ])

        get :index, format: :json, start_time: start_time, end_time: end_time, duration: duration

        response.body.should == slots.to_json
      end
    end

  end

  private

  def create_slots(definition)
    slots = []

    (0..(definition[:quantity] - 1)).each do |x|
      busy = definition[:busy][x] || definition[:busy][0] || []
      monkeys = definition[:monkeys][x] || definition[:monkeys][0] || []
      
      start_time = Time.parse(definition[:start_time]) + x * 30.minutes
      slot = {
        monkeys: monkeys,
        start_time: start_time,
        duration: definition[:duration],
        busy: busy
      }

      slots << slot
    end

    { 
      start_time: Time.parse(definition[:start_time]),
      end_time: Time.parse(definition[:end_time]),
      slots: slots 
    }

  end

end
