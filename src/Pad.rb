
class Pad
	attr_reader :id, :x,:y, :controls, :size
	attr_accessor :score

	def initialize args
		@id = args[:id]
		@playing_area = args[:playing_area]
		@y = (@playing_area.h / 2)
		@color = Gosu::Color.argb 0xff_000000
		@size = {
			w: 16,
			h: 64
		}
		@score = 0
		case @id
		when 0
			@x = 32
		when 1
			@x = @playing_area.w - 32
		else
			@x = 0
		end

		@controls = $controls[@id]
		@@step = 4
	end

	def move id
		case id
		when :up
			@y -= @@step  unless (@y - (@size[:h] / 2) <= 0)
		when :down
			@y += @@step  unless (@y + (@size[:h] / 2) >= @playing_area.h)
		end
	end

	def draw
		Gosu.draw_rect (@x - (@size[:w] / 2)), (@y - (@size[:h] / 2)), @size[:w], @size[:h], @color
	end
end

