
class Menu
	attr_reader :screen

	def initialize args
		@screen = args[:screen]
		@buttons = [
			StartButton.new(menu: self),
			ControlSelectButton.new(
				menu: self,
				x:    (@screen.playing_area.w / 4),
				y:    (@screen.playing_area.h / 2 - 24),
				size: { w: 32, h: 32 },
				pid:  0,
				dir:  :up
			),
			ControlSelectButton.new(
				menu: self,
				x:    (@screen.playing_area.w / 4),
				y:    (@screen.playing_area.h / 2 + 24),
				size: { w: 32, h: 32 },
				pid:  0,
				dir:  :down
			),
			ControlSelectButton.new(
				menu: self,
				x:    ((@screen.playing_area.w / 4) * 3),
				y:    (@screen.playing_area.h / 2 - 24),
				size: { w: 32, h: 32 },
				pid:  1,
				dir:  :up
			),
			ControlSelectButton.new(
				menu: self,
				x:    ((@screen.playing_area.w / 4) * 3),
				y:    (@screen.playing_area.h / 2 + 24),
				size: { w: 32, h: 32 },
				pid:  1,
				dir:  :down
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
	end

	def button_down id
		@buttons.each do |btn|
			if (btn.class == ControlSelectButton)
				btn.button_down id
			end
		end
	end

	def click
		@buttons.each &:click
	end

	def update
		@buttons.each &:update
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
	end
end

