
class Panel
	def initialize args
		@w = args[:w]
		@h = args[:h]
		@x = args[:x]
		@y = args[:y]
		@players = args[:players]
		@@font = Gosu::Font.new 32
		@@bgcolor = Gosu::Color.argb 0xff_444444
		@@txtcolor = Gosu::Color.argb 0xff_ffffff
	end

	def draw
		# Draw background
		Gosu.draw_rect @x,@y, @w,@h, @@bgcolor
		# Draw Player scores
		@@font.draw @players[0].score, (@x + 16),(@y + 16), 1, 1,1, @@txtcolor
		@@font.draw @players[1].score, (@w - 32),(@y + 16), 1, 1,1, @@txtcolor
	end
end

