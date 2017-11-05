
class Screen
	attr_reader :w, :h, :playing_area

	def initialize args
		@w = args[:w]
		@h = args[:h]
		@playing_area = PlayingArea.new w: @w, h: (@h - 64)
	end

	def draw
		@playing_area.draw
	end
end

