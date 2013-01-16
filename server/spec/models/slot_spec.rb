require 'spec_helper'

describe Slot do 

  let(:slot) do
    Slot.new(
      start_time: Time.local(2013), 
      duration: 1.hour)
  end

  let(:ongoing) do
    {
      name: "name",
      start: time = Time.local(2013,1,1,0,30),
      end: time + 1.hour
    }
  end

  let(:past) do
    {
      name: "name",
      start: time = Time.local(2012,12,31,23,00),
      end: time + 1.hour
    }
  end

  let(:future) do
    {
      name: "name",
      start: time = Time.local(2013,1,1,1,00),
      end: time + 1.hour
    }
  end

  let(:monkey) do
    MonkeyCredential.new(email: "rhesus@scvsoft.com", token: "token1" ) 
  end

  it "has an available monkey when he has no events" do
    slot.check_availability(monkey, [])
    
    slot.monkeys.should include(monkey.email)
    slot.busy.should be_empty
  end

  it "has a busy monkey when he has an ongoing event" do
    slot.check_availability(monkey, [ongoing])
    
    slot.monkeys.should be_empty
    slot.busy.should include(monkey.email)
  end

  it "has an available monkey when past and future events don't overlap" do
    slot.check_availability(monkey, [past, future])
    
    slot.monkeys.should include(monkey.email)
    slot.busy.should be_empty
  end

  it "has an available monkey when an event ends at slot's start time" do
    slot.check_availability(monkey, [past])
    
    slot.monkeys.should include(monkey.email)
    slot.busy.should be_empty
  end

  it "has an available monkey when an event starts at slot's end time" do
    slot.check_availability(monkey, [past])
    
    slot.monkeys.should include(monkey.email)
    slot.busy.should be_empty
  end

end