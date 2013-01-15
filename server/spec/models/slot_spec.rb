require 'spec_helper'

describe Slot do 

  let(:slot) do
    Slot.new(
      start_time: Time.local(2013), 
      duration: 1.hour)
  end

  let(:monkeys) do
    [ 
      MonkeyCredential.new(email: "rhesus@scvsoft.com", token: "token1" ), 
      MonkeyCredential.new(email: "chimp@scvsoft.com", token: "token2") 
    ]
  end

  it "has a monkey when he has no events" do
    slot.check_availability(monkeys[0], [])
    slot.monkeys[0].should eq monkeys[0].email
  end

  it "has a busy monkey when he has one event" do
    slot.check_availability(monkeys[0], [{
        name: "name",
        start: Time.local(2013),
        end: Time.local(2013) + 1.hour
      }])
    slot.busy[0].should eq monkeys[0].email
  end

end