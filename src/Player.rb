
class Player < Pad
	def init
		@color = Gosu::Color.argb 0xff_000000
	end

	def update_control args
		@controls[args[:dir]] = [args[:key]]
		return args[:key]
	end
end

