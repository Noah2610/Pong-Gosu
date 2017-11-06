
class Screen
	attr_reader :w, :h, :playing_area

	def initialize args
		@w = args[:w]
		@h = args[:h]
		@playing_area = PlayingArea.new w: @w, h: (@h - 64)
		@panel = Panel.new w: @w, h: 64, x: 0, y: (@h - 64), players: @playing_area.players, cpu_players: @playing_area.cpu_players
	end

	def draw
		@playing_area.draw
		@panel.draw
	end
end

