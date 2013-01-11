class Slot
	attr_accessor :monkeys, :start_time, :end_time, :busy

	def initialize(monkeys, start_time, end_time, busy)
		@monkeys = monkeys
		@start_time = start_time
		@end_time = end_time
		@busy = busy
	end
end
