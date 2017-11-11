
class Screen
	attr_reader :w, :h, :playing_area

	def initialize args
		@w = args[:w]
		@h = args[:h]
		@playing_area = PlayingArea.new w: @w, h: (@h - 64)
		@panel = Panel.new w: @w, h: 64, x: 0, y: (@h - 64), pads: @playing_area.pads, balls: @playing_area.balls
		@menu = Menu.new screen: self
	end

	def button_down id
		if (@menu)
			@menu.button_down id
		end
	end

	def click
		@menu.click  unless ($game_running)
	end

	def update
		@playing_area.update
	end

	def draw
		@playing_area.draw
		@panel.draw
		unless ($game_running)
			@menu.update
			@menu.draw
		end
	end
end

