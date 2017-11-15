
class Player < Pad
	def init
		@color = Gosu::Color.argb 0xff_000000
	end

	def update_control args
		@controls[args[:dir]] = [args[:key]]
		$settings.set :controls, [args[:key]], id: @id, dir: args[:dir]
		return args[:key]
	end
end

