
class Pad
	attr_reader :id, :x,:y, :size, :controls
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

		@controls = CONTROLS[@id]
		@@speed = 4
		@speed = @@speed

		init
	end

	def init
	end
	def update
		# Player controls
		@controls.each do |k,v|
			v.each do |btn|
				move k  if (Gosu.button_down? btn)
			end
		end
	end

	def move id
		speed_incr = 0
		@playing_area.balls.each do |ball|
			speed_incr = ball.speed[:y].floor - 1  if (ball.speed[:y].floor - 1 > speed_incr)
		end
		@speed = @@speed + speed_incr
		dir = 0
		case id
		when :up
			dir = -1  unless (@y - (@size[:h] / 2) <= 0)
		when :down
			dir = 1   unless (@y + (@size[:h] / 2) >= @playing_area.h)
		else
			return
		end

		@speed.floor.times do |n|
			@y += dir
		end
	end

	def draw
		# Draw Pad
		Gosu.draw_rect (@x - (@size[:w] / 2)), (@y - (@size[:h] / 2)), @size[:w], @size[:h], @color
		# Draw debugging lines, Pad part separators (not dynamic, doesn't adjust to actual collision checking method)
		#Gosu.draw_rect (@x - (@size[:w] / 2)), (@y - (@size[:h] / 4)), @size[:w], 2, Gosu::Color.argb(0xff_ff0000)
		#Gosu.draw_rect (@x - (@size[:w] / 2)), (@y + (@size[:h] / 4)), @size[:w], 2, Gosu::Color.argb(0xff_ff0000)
	end
end

