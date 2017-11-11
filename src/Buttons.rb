
class Button
	def initialize args
		@menu = args[:menu]
		@x = args[:x] || (@menu.screen.playing_area.w / 2)
		@y = args[:y] || (@menu.screen.playing_area.h / 2)
		@size = args[:size] || { w: 128, h: 42 }
		@default_color = {
			bg:     Gosu::Color.argb(0xff_aaaaaa),
			fg:     Gosu::Color.argb(0xff_000000),
			border: Gosu::Color.argb(0xff_444444)
		}
		@hover_color = {
			bg:     Gosu::Color.argb(0xff_888888),
			fg:     Gosu::Color.argb(0xff_000000),
			border: Gosu::Color.argb(0xff_444444)
		}
		@active_color = {
			bg:     Gosu::Color.argb(0xff_444444),
			fg:     Gosu::Color.argb(0xff_cccccc),
			border: Gosu::Color.argb(0xff_000000)
		}
		@color = @default_color
		@border_width = 2
		@font = Gosu::Font.new(args[:font_size] || 24)
		@text = "BUTTON"
		@last_in_collision = false
		init args  if (defined? init)
	end

	def collision? x, y
		if (x >= (@x - (@size[:w] / 2)) && x <= (@x + (@size[:w] / 2)) &&
			  y >= (@y - (@size[:h] / 2)) && y <= (@y + (@size[:h] / 2)))
			return true
		end
		return false
	end

	def click!
	end

	def click
		if (@last_in_collision)
			click!
		end
	end

	def update
		# Check collision with mouse
		in_collision = collision? $game.mouse_x, $game.mouse_y
		if (in_collision)
			@color = @hover_color
		else
			@color = @default_color
		end
		@last_in_collision = in_collision
	end

	def draw
		x = @x - (@size[:w] / 2)
		y = @y - (@size[:h] / 2)
		# Draw border
		Gosu.draw_rect x,y, (@size[:w]),(@size[:h]), @color[:border]
		# Draw bg
		Gosu.draw_rect (x + @border_width),(y + @border_width), (@size[:w] - @border_width * 2),(@size[:h] - @border_width * 2), @color[:bg]
		# Draw text
		@font.draw_rel @text, @x,@y, 1, 0.5,0.5, 1,1, @color[:fg]
	end
end


class StartButton < Button
	def init args
		@text = "Start!"
	end

	def click!
		@menu.screen.playing_area.start_game
	end
end


class ControlSelectButton < Button
	def init args
		@dir = args[:dir]
		case @dir
		when :up
			@text = "/\\"
		when :down
			@text = "\\/"
		end
		@pid = args[:pid]
		@@active = nil
	end

	def button_down id
		if (@@active == self)
			ret = @menu.screen.playing_area.set_control id: @pid, key: id, dir: @dir
			if (ret)
				@text = VALID_BUTTONS[ret]
				@@active = nil
			end
		end
	end

	def click!
		if (@@active != self)
			@@active = self
		else
			@@active = nil
		end
	end

	def update
		in_collision = collision? $game.mouse_x, $game.mouse_y
		if (@@active == self)
			@color = @active_color
		elsif (in_collision)
			@color = @hover_color
		else
			@color = @default_color
		end
		@last_in_collision = in_collision
	end
end

