
class Pad
	attr_reader :id, :x,:y, :size, :controls, :speed, :segment_size, :speed_increment
	attr_accessor :score

	def initialize args
		@id = args[:id]
		@playing_area = args[:playing_area]
		@y = (@playing_area.h / 2)
		@color = Gosu::Color.argb 0xff_000000
		@size = PAD_SIZE.dup
		@score = 0
		case @id
		when 0
			@x = 32
		when 1
			@x = @playing_area.w - 32
		else
			@x = 0
		end

		@controls = CONTROLS[@id].dup
		@start_speed = PAD_SPEED.dup
		@speed = @start_speed.dup
		@segment_size = 1.0 / 4.0
		@speed_increment = true

		init
	end

	def init
	end

	def set_start_speed speed
		@start_speed = speed.to_f
		@speed = @start_speed
	end

	def set_speed speed
		@start_speed = speed
		@speed = @start_speed
	end

	def set_height height
		@size[:h] = height
	end

	def set_speed_increment state
		@speed_increment = !!state
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
		if (@speed_increment)
			speed_incr = 0
			@playing_area.balls.each do |ball|
				speed_incr = ball.speed[:y].floor - 1  if (ball.speed[:y].floor - 1 > speed_incr)
			end
			@speed = @start_speed + speed_incr
		end
		dir = 0
		case id
		when :up
			dir = -1  unless (@y - (@size[:h] / 2) <= 0)
		when :down
			dir = 1   unless (@y + (@size[:h] / 2) >= @playing_area.h)
		else
			return
		end
		return :border_collision  if (dir == 0)

		@speed.floor.times do |n|
			@y += dir
		end
	end

	def draw
		# Draw Pad
		Gosu.draw_rect (@x - (@size[:w] / 2)), (@y - (@size[:h] / 2)), @size[:w], @size[:h], @color
		# Draw debugging lines, Pad part separators (not dynamic, doesn't adjust to actual collision checking method)
		if (@playing_area.screen.menu.page == :settings_pad)
			Gosu.draw_rect (@x - (@size[:w] / 2)), (@y - (@size[:h] * @segment_size)), @size[:w], 2, Gosu::Color.argb(0xff_ff0000)
			Gosu.draw_rect (@x - (@size[:w] / 2)), (@y + (@size[:h] * @segment_size)), @size[:w], 2, Gosu::Color.argb(0xff_ff0000)
		end
	end
end

