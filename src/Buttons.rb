
class Button
	def initialize args
		initialize_defaults args
		initialize_button args
		init args  if (defined? init)
	end

	def initialize_defaults args
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
		@last_in_collision = false
		@show = false
	end

	def initialize_button args
		@text = "BUTTON"
	end

	def show
		@show = true
	end
	def hide
		@show = false
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
		return  if (!@show || @menu.has_clicked)
		if (@last_in_collision)
			@menu.has_clicked = true
			click!
		end
	end

	def update
		return  unless (@show)
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
		return  unless (@show)
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
	attr_reader :pid
	def init args
		@dir = args[:dir]
		@pid = args[:pid]
		@text = btn_id_to_char(@menu.screen.playing_area.player(@pid).controls[@dir][0]).upcase
		@@active = nil
		@show = false  if (@menu.screen.playing_area.player(@pid).class == Cpu)
	end

	def show
		unless (@menu.screen.playing_area.player(@pid).class == Cpu)
			@show = true
		end
	end

	def button_down id
		if (@@active == self)
			ret = @menu.screen.playing_area.set_control id: @pid, key: id, dir: @dir
			if (ret)
				@text = btn_id_to_char(ret).upcase
				@@active = nil
			end
			return true
		end
		return false
	end

	def click!
		if (@@active != self)
			@@active = self
		else
			@@active = nil
		end
	end

	def update
		if (@show)
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
end


class TogglePadTypeButton < Button
	def init args
		@pid = args[:pid] || 0
		@state = args[:state] || :player
		@text = @state.to_s.upcase
	end

	def click!
		if (@state == :player)
			@state = :cpu
		elsif (@state == :cpu)
			@state = :player
		end
		@text = @state.to_s.upcase
		@menu.screen.playing_area.set_pad id: @pid, type: @state
		@menu.update_buttons pid: @pid
	end
end


class ShowSettingsButton < Button
	def init args
		@text = "Settings"
	end

	def click!
		@menu.show_settings
	end
end



class ShowMainButton < Button
	def init args
		@text = "Back"
	end

	def click!
		@menu.show_main
	end
end



### Text Input Buttons ###
class TextInput < Button
	def initialize args
		initialize_defaults args
		initialize_input args
		init args  if (defined? init)
	end

	def initialize_input args
		@@active = nil
		@text = "TEXT INPUT"
	end

	def button_down id
		if (@@active == self)
			case id
			when Gosu::KB_RETURN
				@@active = nil
			when Gosu::KB_BACKSPACE
				unless (@text.length == 0)
					if (Gosu.button_down?(Gosu::KB_LEFT_SHIFT) || Gosu.button_down?(Gosu::KB_RIGHT_SHIFT))
						@text = ""
					else
						@text[-1] = ""
					end
				end
			else
				if (Gosu.button_down?(Gosu::KB_LEFT_SHIFT) || Gosu.button_down?(Gosu::KB_RIGHT_SHIFT))
					@text += Gosu.button_id_to_char(id).upcase
				else
					@text += Gosu.button_id_to_char(id)
				end
			end
			return true
		end
		return false
	end

	def update
		return  unless (@show)
		# Check collision with mouse
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

	def click!
		if (@@active != self)
			@@active = self
		elsif (@@active == self)
			@@active = nil
		end
	end
end

class TestInput < TextInput
	def init args
		@text = "Test Input"
	end
end

