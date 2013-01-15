require 'spec_helper'

describe SlotRange do
  
  let(:slot_range) do
    SlotRange.new(
      Time.local(2013), 
      Time.local(2013) + 3.hours, 1.hour)
  end

  it "is invalid without start_time" do
    lambda do
      SlotRange.new(nil, Time.now, 1.hour)
    end.should raise_error
  end
  
  it "is invalid without end_time" do
    lambda do
      SlotRange.new(Time.now, nil, 1.hour)
    end.should raise_error
  end
  
  it "is invalid without duration" do
    lambda do
      SlotRange.new(Time.now, Time.now, nil)
    end.should raise_error
  end
  
  it "has a set of 5 1-hour Slots in a 3-hours window" do
    slot_range.slots.size.should eq 5
  end

end
