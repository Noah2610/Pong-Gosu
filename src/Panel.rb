
class Panel
	def initialize args
		@w = args[:w]
		@h = args[:h]
		@x = args[:x]
		@y = args[:y]
		@players = args[:players]
		@cpu_players = args[:cpu_players]
		@@font = Gosu::Font.new 32
		@@bgcolor = Gosu::Color.argb 0xff_444444
		@@txtcolor = Gosu::Color.argb 0xff_ffffff
	end

	def draw
		# Draw background
		Gosu.draw_rect @x,@y, @w,@h, @@bgcolor
		# Draw Player scores
		@players.each do |p|
			case p.id
			when 0
				@@font.draw p.score, (@x + 16),(@y + 16), 1, 1,1, @@txtcolor
			when 1
				@@font.draw p.score, (@w - 32),(@y + 16), 1, 1,1, @@txtcolor
			end
		end
		# Draw Cpu Player scores
		@cpu_players.each do |p|
			case p.id
			when 0
				@@font.draw p.score, (@x + 16),(@y + 16), 1, 1,1, @@txtcolor
			when 1
				@@font.draw p.score, (@w - 32),(@y + 16), 1, 1,1, @@txtcolor
			end
		end
	end
end

