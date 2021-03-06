
class Menu
	attr_reader :screen, :page
	attr_accessor :has_clicked

	def initialize args
		@screen = args[:screen]
		@show = true
		@has_clicked = false
		@inputs = {
			main: [
				StartButton.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 2),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 2)
				),
				CloseButton.new(
					menu:  self,
					x:     (@screen.w - 32),
					y:     32,
					size:  { w: 32, h: 32 }
				),
				# Set Player control buttons
				ControlSelectButton.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 4),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 2 - 24),
					size:  { w: 32, h: 32 },
					pid:   0,
					dir:   :up
				),
				ControlSelectButton.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 4),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 2 + 24),
					size:  { w: 32, h: 32 },
					pid:   0,
					dir:   :down
				),
				ControlSelectButton.new(
					menu:  self,
					x:     (((@screen.playing_area.x + @screen.playing_area.w) / 4) * 3),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 2 - 24),
					size:  { w: 32, h: 32 },
					pid:   1,
					dir:   :up
				),
				ControlSelectButton.new(
					menu:  self,
					x:     (((@screen.playing_area.x + @screen.playing_area.w) / 4) * 3),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 2 + 24),
					size:  { w: 32, h: 32 },
					pid:   1,
					dir:   :down
				),
				# Toggle Pad Type buttons
				TogglePadTypeButton.new(
					menu:  self,
					pid:   0,
					state: :player,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 4),
					y:     (((@screen.playing_area.y + @screen.playing_area.h) / 4) * 3.25)
				),
				TogglePadTypeButton.new(
					menu:  self,
					pid:   1,
					state: :cpu,
					x:     (((@screen.playing_area.x + @screen.playing_area.w) / 4) * 3),
					y:     (((@screen.playing_area.y + @screen.playing_area.h) / 4) * 3.25)
				),
				ShowSettingsButton.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 2),
					y:     (((@screen.playing_area.y + @screen.playing_area.h) / 4) * 3.25)
				)
			],
			settings: [
				ShowMainButton.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 2),
					y:     (((@screen.playing_area.y + @screen.playing_area.h) / 4) * 3.25)
				),
				ShowGeneralSettingsButton.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 2),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 4),
					size:  { w: 192, h: 42 }
				),
				ShowPadSettingsButton.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 2),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 4 * 1.5),
					size:  { w: 192, h: 42 }
				),
				ShowBallSettingsButton.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 2),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 2),
					size:  { w: 192, h: 42 }
				),
				# Export settings to file input
				ExportSettingsInput.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 2),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 4 * 2.7),
					size:  { w: 192, h: 42 },
				)
			],

			# GENERAL SETTINGS
			settings_general: [
				ShowSettingsButton.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 2),
					y:     (((@screen.playing_area.y + @screen.playing_area.h) / 4) * 3.25),
					text:  "Back"
				),
				# Toggle multiple balls button
				ToggleMultipleBallsButton.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 3),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 2 * 1.1)
				),
				# Screen resolution
				SetScreenResolutionInput.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 2 * 0.85),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 4 * 1.5),
					axis:  :x
				),
				SetScreenResolutionInput.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 2 * 1.15),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 4 * 1.5),
					axis:  :y
				),
				# Mulitple balls delay
				MultipleBallsDelayInput.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 3 * 2),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 2 * 1.1)
				)
			],

			# PAD SETTINGS
			settings_pad: [
				ShowSettingsButton.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 2),
					y:     (((@screen.playing_area.y + @screen.playing_area.h) / 4) * 3.25),
					text:  "Back"
				),
				# TOGGLE PAD SPEED INCREMENTATION
				# all Pads
				PadSpeedIncrementInput.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 2),
					y:     (((@screen.playing_area.y + @screen.playing_area.h) / 4) * 2.5),
					pid:   :all
				),
				# Pad id 0
				PadSpeedIncrementInput.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 4),
					y:     (((@screen.playing_area.y + @screen.playing_area.h) / 4) * 2.5),
					pid:   0
				),
				# Pad id 1
				PadSpeedIncrementInput.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 4 * 3),
					y:     (((@screen.playing_area.y + @screen.playing_area.h) / 4) * 2.5),
					pid:   1
				),
				# SPEED
				# all Pads
				PadSpeedInput.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 2),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 4 * 1.5),
					pid:   :all
				),
				# Pad id 0
				PadSpeedInput.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 4),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 4 * 1.5),
					pid:   0
				),
				# Pad id 1
				PadSpeedInput.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 4 * 3),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 4 * 1.5),
					pid:   1
				),

				# HEIGHT
				# all Pads
				PadHeightInput.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 2),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 2),
					pid:   :all
				),
				# Pad id 0
				PadHeightInput.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 4),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 2),
					pid:   0
				),
				# Pad id 1
				PadHeightInput.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 4 * 3),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 2),
					pid:   1
				)
			],

			# BALL SETTINGS
			settings_ball: [
				ShowSettingsButton.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 2),
					y:     (((@screen.playing_area.y + @screen.playing_area.h) / 4) * 3.25),
					text:  "Back"
				),
				# Ball Spawn Delay
				BallDelayInput.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 3),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 4)
				),
				# Ball Starting Direction y
				BallStartDirYButton.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 3),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 4 * 1.5),
					dir:   -1
				),
				BallStartDirYButton.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 3 - 16),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 4 * 1.75),
					dir:   0
				),
				BallStartDirYButton.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 3 + 16),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 4 * 1.75),
					dir:   :random
				),
				BallStartDirYButton.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 3),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 2),
					dir:   1
				),
				# Ball Starting Speed
				BallStartSpeedInput.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 3 * 2),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 4)
				),
				# Ball Speed Incrementation
				BallSpeedIncrementInput.new(
					menu:  self,
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 3 * 2),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 4 * 1.5)
				)
			]
		}

		@title = {
			text:   {
				main:              "Pong!",
				settings:          "Settings",
				settings_general:  "General Settings",
				settings_pad:      "Pad Settings",
				settings_ball:     "Ball Settings"
			},
			font:   Gosu::Font.new(64),
			color:  Gosu::Color.argb(0xff_aa4444),
			x:      ((@screen.playing_area.x + @screen.playing_area.w) / 2),
			y:      ((@screen.playing_area.y + @screen.playing_area.h) / 8)
		}
		@footer = {
			text:   ["by Noah Rosenzweig", "2017"],
			font:   Gosu::Font.new(16),
			color:  Gosu::Color.argb(0xff_cccccc),
			x:      ((@screen.playing_area.x + @screen.playing_area.w) / 2),
			y:      ((@screen.playing_area.y + @screen.playing_area.h) - 32)
		}
		@texts = {
			main: [],
			settings: [],
			settings_general: [
				{
					text:  "Screen Resolution (requires saving settings, then restart)",
					font:  Gosu::Font.new(32),
					color: Gosu::Color.argb(0xff_6644aa),
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 2),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 4)
				},
				{
					text:  "x",
					font:  Gosu::Font.new(24),
					color: Gosu::Color.argb(0xff_000000),
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 2),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 4 * 1.5)
				}
			],
			settings_ball: [],
			settings_pad: [
				{
					text:  "All Pads",
					font:  Gosu::Font.new(32),
					color: Gosu::Color.argb(0xff_6644aa),
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 2),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 4)
				},
				{
					text:  "Pad 1",
					font:  Gosu::Font.new(32),
					color: Gosu::Color.argb(0xff_6644aa),
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 4),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 4)
				},
				{
					text:  "Pad 2",
					font:  Gosu::Font.new(32),
					color: Gosu::Color.argb(0xff_6644aa),
					x:     ((@screen.playing_area.x + @screen.playing_area.w) / 4 * 3),
					y:     ((@screen.playing_area.y + @screen.playing_area.h) / 4)
				}
			]
		}

		@page = :none

		show :main
	end

	def show page
		@page = page
		@inputs.each do |k,v|
			if (k != page)
				v.each &:hide
			elsif (k == page)
				v.each &:show
			end
		end
		if (page == :settings_ball)
			@screen.playing_area.demo_game = true
			ball_reset
		else
			@screen.playing_area.demo_game = false
			@screen.playing_area.ball_reset
		end
	end

	def ball_reset
		@screen.playing_area.ball_reset
	end

	def update_buttons args
		@inputs[:main].each do |btn|
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
		@inputs.each do |k,v|
			v.each do |inst|
				return  if (inst.button_down(id))
			end
		end
		if (!$game_running && (id == Gosu::KB_SPACE || id == Gosu::KB_RETURN))
			@screen.playing_area.start_game
		end
	end

	def click
		@inputs.each do |k,v|
			v.each &:click
		end
	end

	def update
		@inputs.each do |k,v|
			v.each &:update
		end

		# Move CPUs as demonstration for :settings_pad page
		@screen.playing_area.cpus_demo_move :up_down  if (@page == :settings_pad)
	end

	def draw
		# Draw title
		@title[:font].draw_rel @title[:text][@page], @title[:x],@title[:y], 1, 0.5,0.5, 1,1, @title[:color]
		# Draw footer
		@footer[:text].each_with_index do |text,count|
			@footer[:font].draw_rel text, @footer[:x],(@footer[:y] + 16 * count), 1, 0.5,0.5, 1,1, @footer[:color]
		end
		# Draw extra @texts
		@texts[@page].each do |group|
			group[:font].draw_rel group[:text], group[:x],group[:y], 1, 0.5,0.5, 1,1, group[:color]
		end
		# Draw inputs
		@inputs.each do |k,v|
			v.each &:draw
		end
	end
end

