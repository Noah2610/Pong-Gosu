
class Menu
	attr_reader :screen
	attr_accessor :has_clicked

	def initialize args
		@screen = args[:screen]
		@show = true
		@has_clicked = false
		@buttons = [
			StartButton.new(
				menu:  self,
				x:     (@screen.playing_area.w / 2),
				y:     (@screen.playing_area.h / 2 - 32)
			),
			# Set Player control buttons
			ControlSelectButton.new(
				menu:  self,
				x:     (@screen.playing_area.w / 4),
				y:     (@screen.playing_area.h / 2 - 24),
				size:  { w: 32, h: 32 },
				pid:   0,
				dir:   :up
			),
			ControlSelectButton.new(
				menu:  self,
				x:     (@screen.playing_area.w / 4),
				y:     (@screen.playing_area.h / 2 + 24),
				size:  { w: 32, h: 32 },
				pid:   0,
				dir:   :down
			),
			ControlSelectButton.new(
				menu:  self,
				x:     ((@screen.playing_area.w / 4) * 3),
				y:     (@screen.playing_area.h / 2 - 24),
				size:  { w: 32, h: 32 },
				pid:   1,
				dir:   :up
			),
			ControlSelectButton.new(
				menu:  self,
				x:     ((@screen.playing_area.w / 4) * 3),
				y:     (@screen.playing_area.h / 2 + 24),
				size:  { w: 32, h: 32 },
				pid:   1,
				dir:   :down
			),
			# Toggle Pad Type buttons
			TogglePadTypeButton.new(
				menu:  self,
				pid:   0,
				state: :player,
				x:     (@screen.playing_area.w / 4),
				y:     (@screen.playing_area.h / 2 + 128),
			),
			TogglePadTypeButton.new(
				menu:  self,
				pid:   1,
				state: :cpu,
				x:     ((@screen.playing_area.w / 4) * 3),
				y:     (@screen.playing_area.h / 2 + 128),
			),
			ShowSettingsButton.new(
				menu:  self,
				x:     (@screen.playing_area.w / 2),
				y:     (@screen.playing_area.h / 2 + 32)
			)
		]

		@buttons_settings = [
			ShowMainButton.new(
				menu:  self,
				x:     (@screen.playing_area.w / 2),
				y:     (@screen.playing_area.h / 2 + 32)
			)
		]

		@title = {
			text:   "Pong!",
			font:   Gosu::Font.new(64),
			color:  Gosu::Color.argb(0xff_ff0000),
			x:      (@screen.playing_area.w / 2),
			y:      64
		}
		@footer = {
			text:   ["by Noah Rosenzweig", "2017"],
			font:   Gosu::Font.new(16),
			color:  Gosu::Color.argb(0xff_cccccc),
			x:      (@screen.playing_area.w / 2),
			y:      (@screen.playing_area.h - 32)
		}

		show_main
	end

	def show_main
		@buttons_settings.each &:hide
		@buttons.each &:show
	end

	def show_settings
		@buttons.each &:hide
		@buttons_settings.each &:show
	end

	def update_buttons args
		@buttons.each do |btn|
			if (btn.class == ControlSelectButton && btn.pid == args[:pid])
				case @screen.playing_area.player(args[:pid]).class.to_s.to_sym
				when :Player
					btn.show
				when :Cpu
					btn.hide
				end
			end
		end
	end

	def button_down id
		@buttons.each do |btn|
			if (btn.class == ControlSelectButton)
				return  if (btn.button_down id)
			end
		end
		if (!$game_running && (id == Gosu::KB_SPACE || id == Gosu::KB_RETURN))
			@screen.playing_area.start_game
		end
	end

	def click
		@buttons.each &:click
		@buttons_settings.each &:click
	end

	def update
		@buttons.each &:update
		@buttons_settings.each &:update
	end

	def draw
		# Draw title
		@title[:font].draw_rel @title[:text], @title[:x],@title[:y], 1, 0.5,0.5, 1,1, @title[:color]
		# Draw footer
		@footer[:text].each_with_index do |text,count|
			@footer[:font].draw_rel text, @footer[:x],(@footer[:y] + 16 * count), 1, 0.5,0.5, 1,1, @footer[:color]
		end
		# Draw buttons
		@buttons.each &:draw
		@buttons_settings.each &:draw
	end
end

