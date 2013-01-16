require 'spec_helper'

describe SlotRange do
  
  let(:slot_range) do
    SlotRange.new(
      Time.local(2013), 
      Time.local(2013) + 3.hours, 1.hour)
  end

  let(:monkeys) do
    [ 
      MonkeyCredential.new(email: "rhesus@scvsoft.com", token: "token1" ), 
      MonkeyCredential.new(email: "chimp@scvsoft.com", token: "token2") 
    ]
  end

  let(:ongoing) do
    {
      name: "name",
      start: time = Time.local(2013,1,1,0,30),
      end: Time.local(2013) + 1.hour
    }
  end


  context "Object construction" do
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
    
    it "has a set of 5 1-hour slots in a 3-hours window" do
      slot_range.slots.size.should eq 5
    end
  end

  context "5-slot processing with 1 monkey" do
    it "has all slots with an available monkey and no busy monkey when no events" do
      slot_range.slot(monkeys[0], [])

      slot_range.slots.each do |slot|
        slot.monkeys.should include(monkeys[0].email)
        slot.busy.should be_empty
      end
    end
    
    it "has a slot with a busy monkey when ongoing event" do
      slot_range.slot(monkeys[0], [ongoing])

      slot_range.slots.first(3).each do |slot|
        slot.monkeys.should be_empty
        slot.busy.should include(monkeys[0].email)
      end

      slot_range.slots.last(2).each do |slot|
        slot.monkeys.should include(monkeys[0].email)
        slot.busy.should be_empty
      end

    end
  end

  context "5-slot processing with 2 monkeys" do
    it "has all slots with available monkeys and no busy monkey when no events" do
      monkeys.each do |ape|
        slot_range.slot(ape, [])
      end

      slot_range.slots.each do |slot|
        slot.monkeys.should == monkeys.map { |m| m.email }
        slot.busy.should be_empty
      end
    end
    
    it "has a slot with a busy monkey and available monkey when ongoing event" do

      slot_range.slot(monkeys[0], [ongoing])
      slot_range.slot(monkeys[1], [])

      # for Chimp (always available)
      slot_range.slots.each do |slot|
        slot.monkeys.should include(monkeys[1].email)
      end

      # for Rhesus
      slot_range.slots.first(3).each do |slot|
        slot.busy.should include(monkeys[0].email)
        slot.monkeys.should_not include(monkeys[0].email)
      end

      slot_range.slots.last(2).each do |slot|
        slot.busy.should_not include(monkeys[0].email)
        slot.monkeys.should include(monkeys[0].email)
      end

    end
  end
end
