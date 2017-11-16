
class Screen
	attr_reader :w,:h, :playing_area, :menu
	attr_accessor :has_clicked

	def initialize args
		@w = args[:w]
		@h = args[:h]
		@playing_area = PlayingArea.new screen: self, w: @w, h: (@h - 64)
		@panel = Panel.new w: @w, h: 64, x: 0, y: (@h - 64), pads: @playing_area.pads, balls: @playing_area.balls
		@menu = Menu.new screen: self
		@has_clicked = false
	end

	def button_down id
		case id
		when Gosu::MS_LEFT, Gosu::MS_RIGHT, Gosu::MS_MIDDLE
			if (!$game_running)
				@menu.click
			elsif ($game_running && $game_paused)
				@playing_area.click
			end
		else
			if (!$game_running)
				@menu.button_down id
			elsif ($game_running)
				@playing_area.button_down id
			end
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

