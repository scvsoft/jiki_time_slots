require 'spec_helper'

describe Slot do

  let(:slot) do
    Slot.new(
      start_time: Time.local(2013),
      duration: 1.hour)
  end

  let(:ongoing) do
    Calendar::Event.new(
      "name",
      time = Time.local(2013,1,1,0,30),
      time + 1.hour)
  end

  let(:past) do
    Calendar::Event.new(
      "name",
      time = Time.local(2012,12,31,23,00),
      time + 1.hour)
  end

  let(:future) do
    Calendar::Event.new(
      "name",
      time = Time.local(2013,1,1,1,00),
      time + 1.hour)
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

  it "has a busy monkey when it has 2 events, one past and one ongoing" do
    slot.check_availability(monkey, [past, ongoing])

    slot.monkeys.should_not include(monkey.email)
    slot.busy.should include(monkey.email)
  end

end