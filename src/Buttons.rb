
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
		@label_color = Gosu::Color.argb(0xff_4444aa)
		@color = @default_color
		@border_width = 2
		@font = Gosu::Font.new(args[:font_size] || 24)
		@label_font = Gosu::Font.new(args[:font_label_size] || 24)
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

	def button_down *args
		false
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
		# Draw label (for TextInput)
		if (defined? @label)
			@label_font.draw_rel @label, @x,(@y - (@size[:h] * 0.75)), 1, 0.5,0.5, 1,1, @label_color
		end

		custom_update  if (defined? custom_update)
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

class CloseButton < Button
	def init args
		@text = "X"
	end
	def click!
		$game.close
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
		@text = args[:text] || "Settings"
	end

	def click!
		@menu.show :settings
	end
end

class ShowMainButton < Button
	def init args
		@text = args[:text] || "Back"
	end
	def click!
		@menu.show :main
	end
end

class ShowGeneralSettingsButton < Button
	def init args
		@text = args[:text] || "General settings"
	end
	def click!
		@menu.show :settings_general
	end
end

class ShowPadSettingsButton < Button
	def init args
		@text = args[:text] || "Pad settings"
	end
	def click!
		@menu.show :settings_pad
	end
end

class ShowBallSettingsButton < Button
	def init args
		@text = args[:text] || "Ball setting"
	end
	def click!
		@menu.show :settings_ball
	end
end



### TEXT INPUT CLASS ###
class TextInput < Button
	def initialize args
		initialize_defaults args
		initialize_input args
		init args  if (defined? init)
	end

	def initialize_input args
		@@active = nil
		@text = "TEXT INPUT"
		@label = args[:label] || nil
		@chars_whitelist = []
		@chars_blacklist = []
	end

	def button_down id
		if (@@active == self)
			case id
			when Gosu::KB_RETURN
				@@active = nil
				input_return  if (defined? input_return)
			when Gosu::KB_BACKSPACE
				unless (@text.length == 0)
					if (Gosu.button_down?(Gosu::KB_LEFT_SHIFT) || Gosu.button_down?(Gosu::KB_RIGHT_SHIFT))
						@text = ""
					else
						@text[-1] = ""
					end
				end
			else
				key = Gosu.button_id_to_char(id)
				if ((@chars_whitelist.empty? || @chars_whitelist.include?(key)) && !@chars_blacklist.include?(key))
					if (Gosu.button_down?(Gosu::KB_LEFT_SHIFT) || Gosu.button_down?(Gosu::KB_RIGHT_SHIFT))
						@text += key.upcase
					else
						@text += key
					end
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

		custom_update  if (defined? custom_update)
	end

	def click!
		if (@@active != self)
			@@active = self
		elsif (@@active == self)
			@@active = nil
		end
	end
end


### SETTINGS BUTTONS/INPUTS ###

### GENERAL SETTINGS BUTTONS/INPUTS ###

### PAD SETTINGS BUTTONS/INPUTS ###
class PadSpeedInput < TextInput
	def init args
		@label = "Speed"
		@size = {
			w: 64,
			h: 32
		}
		@pid = args[:pid] || :all
		if (@pid == :all)
			@text = PAD_SPEED.to_s
		elsif (@pid.is_a? Integer)
			@text = @menu.screen.playing_area.player(@pid).speed.to_s
		end
		@chars_whitelist = ("0".."9").to_a.concat([".",","])
	end

	def input_return
		# set speed of pad(s)
		speed = @text.gsub(",",".").to_f.round
		if (@pid == :all)
			[0,1].each { |i| @menu.screen.playing_area.player(i).set_start_speed speed }
			@text = speed.to_s
		elsif (@pid.is_a? Integer)
			@menu.screen.playing_area.player(@pid).set_start_speed speed
		end
	end

	def custom_update
		@text = @menu.screen.playing_area.player(@pid).speed.to_i.to_s  if (@@active != self && @pid.is_a?(Integer))
	end
end

class PadHeightInput < TextInput
	def init args
		@label = "Height"
		@size = {
			w: 64,
			h: 32
		}
		@pid = args[:pid] || :all
		if (@pid == :all)
			@text = PAD_SIZE[:h].to_s
		elsif (@pid.is_a? Integer)
			@text = @menu.screen.playing_area.player(@pid).size[:h].to_s
		end
		@chars_whitelist = ("0".."9").to_a.concat([".",","])
	end

	def input_return
		# set height of pad(s)
		height = @text.gsub(",",".").to_f.round
		if (@pid == :all)
			[0,1].each { |i| @menu.screen.playing_area.player(i).set_height height }
			@text = height.to_s
		elsif (@pid.is_a? Integer)
			@menu.screen.playing_area.player(@pid).set_height height
		end
	end

	def custom_update
		@text = @menu.screen.playing_area.player(@pid).size[:h].to_i.to_s  if (@@active != self && @pid.is_a?(Integer))
	end
end

class PadSpeedIncrementInput < Button
	def init args
		@label = "Increment speed?"
		@size = {
			w: 64,
			h: 32
		}
		@pid = args[:pid] || :all
		if (@pid == :all)
			@text = "YES"
		elsif (@pid.is_a? Integer)
			@text = @menu.screen.playing_area.player(@pid).speed_increment ? "YES" : "NO"
		end
	end

	def click!
		case @pid
		when :all
			case @text
			when "YES"
				[0,1].each { |i| @menu.screen.playing_area.player(i).set_speed_increment false }
			when "NO"
				[0,1].each { |i| @menu.screen.playing_area.player(i).set_speed_increment true }
			end
			@text = (@text == "YES") ? "NO" : (@text == "NO" ? "YES" : "-")
		else
			if (@pid.is_a? Integer)
				case @text
				when "YES"
					@menu.screen.playing_area.player(@pid).set_speed_increment false
				when "NO"
					@menu.screen.playing_area.player(@pid).set_speed_increment true
				end
			end
		end
	end

	def custom_update
		@text = @menu.screen.playing_area.player(@pid).speed_increment ? "YES" : "NO"  if (@pid.is_a? Integer)
	end
end

### BALL SETTINGS BUTTONS/INPUTS ###


