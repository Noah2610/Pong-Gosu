
class PlayingArea
	attr_reader :w, :h, :players, :balls

	def initialize args
		@w = args[:w]
		@h = args[:h]
		@players = [
			Pad.new(id: 0, playing_area: self),
			Pad.new(id: 1, playing_area: self)
		]
		@balls = [
			Ball.new(playing_area: self)
		]
	end

	def draw
		# Draw Background
		color = Gosu::Color.argb(0xff_ffffff)
		Gosu.draw_rect 0,0, @w,@h, color

		# Draw Players / Pads
		@players.each &:draw

		# Draw Ball(s)
		@balls.each &:draw
	end
end

