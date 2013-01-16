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
      end: Time.local(2013) + 1.hour
    }
  end

  let(:monkey) do
      MonkeyCredential.new(email: "rhesus@scvsoft.com", token: "token1" ) 
  end

  it "has a monkey when he has no events" do
    slot.check_availability(monkey, [])
    slot.monkeys[0].should eq monkey.email
  end

  it "has a busy monkey when he has an ongoing event" do
    slot.check_availability(monkey, [ongoing])
    slot.busy[0].should eq monkey.email
  end

end