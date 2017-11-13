
class Panel
	def initialize args
		@w = args[:w]
		@h = args[:h]
		@x = args[:x]
		@y = args[:y]
		@pads = args[:pads]
		@balls = args[:balls]
		@@font = Gosu::Font.new 32
		@@bgcolor = Gosu::Color.argb 0xff_444444
		@@txtcolor = Gosu::Color.argb 0xff_ffffff
		@@countdown_font = Gosu::Font.new 64
		@@countdown_color = Gosu::Color.argb 0xff_4466ff
		@@countdown_color_indicator = Gosu::Color.argb 0xff_888888
	end

	def draw
		# Draw background
		Gosu.draw_rect @x,@y, @w,@h, @@bgcolor
		# Draw Pad scores
		if ($game_running)
			@pads.each do |p|
				case p.id
				when 0
					@@font.draw_rel p.score, (@x + 42),(@y + @h / 2), 1, 0.5,0.5, 1,1, @@txtcolor
				when 1
					@@font.draw_rel p.score, (@w - 42),(@y + @h / 2), 1, 0.5,0.5, 1,1, @@txtcolor
				end
			end
		end

		# Draw Ball countdown after reset
		@balls.each do |ball|
			if (Time.now <= ball.reset_time)
				# Draw countdown
				remaining = ((ball.reset_time - Time.now).to_i + 1).to_s
				@@countdown_font.draw_rel remaining, (@x + @w / 2),(@y + @h / 2), 1, 0.5, 0.5, 1,1, @@countdown_color
				# Draw direction indicator
				if    (ball.dir[:x] == 1)
					@@countdown_font.draw_rel ">", (@x + @w / 2), (@y + @h / 2), 1, -2, 0.5, 1,1, @@countdown_color_indicator
				elsif (ball.dir[:x] == -1)
					@@countdown_font.draw_rel "<", (@x + @w / 2), (@y + @h / 2), 1, 3, 0.5, 1,1, @@countdown_color_indicator
				end
			elsif (Time.now <= ball.reset_time + 1)
				@@countdown_font.draw_rel "Go!", (@x + @w / 2),(@y + @h / 2), 1, 0.5, 0.5, 1,1, @@countdown_color
			end
		end  unless ($game_paused)
	end
end

