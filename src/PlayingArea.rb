
class PlayingArea
	attr_reader :w, :h, :players, :ball

	def initialize args
		@w = args[:w]
		@h = args[:h]
		@players = [
			Pad.new(id: 0, playing_area: self),
			Pad.new(id: 1, playing_area: self)
		]
		@ball = Ball.new playing_area: self
		@@font = Gosu::Font.new 32
	end

	def draw
		# Draw Background
		color = Gosu::Color.argb(0xff_ffffff)
		Gosu.draw_rect 0,0, @w,@h, color

		# Draw Players / Pads
		@players.each &:draw

		# Draw Ball
		@ball.draw

		# Draw scores
		@@font.draw @players[0].score, 16,16, 1, 1,1, Gosu::Color.argb(0xff_ff0000)
		@@font.draw @players[1].score, (@w - 32),16, 1, 1,1, Gosu::Color.argb(0xff_ff0000)
	end
end

