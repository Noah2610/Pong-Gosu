
class Pad
	attr_reader :id, :x,:y, :size, :controls, :speed, :segment_size, :speed_increment
	attr_accessor :score

	def initialize args
		@id = args[:id]
		@playing_area = args[:playing_area]
		@y = (@playing_area.y + @playing_area.h / 2)
		@color = Gosu::Color.argb 0xff_000000
		@score = 0
		@offset = @playing_area.pad_offset
		case @id
		when 0
			@x = @playing_area.x + @offset
		when 1
			@x = @playing_area.x + @playing_area.w - @offset
		else
			@x = @playing_area.x
		end

		@segment_size = 1.0 / 4.0

		@effect_wearoffs = {
			spd_up: nil
		}

		load_settings

		init
	end

	def init
	end

	def load_settings
		settings = $settings.pad
		@controls = settings[:controls][@id]
		@size = settings[:size]
		@start_speed = settings[:base_speed]
		@speed = @start_speed.dup
		@speed_increment = settings[:speed_incr]
	end

	def add_effect type
		case type
		when :spd_up
			@speed *= 2
			@effect_wearoffs[:spd_up] = Time.now + 5
		end
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

	def handle_effect_wearoffs
		@effect_wearoffs.each do |type,wearoff|
			if (!wearoff.nil? && Time.now > wearoff)
				@effect_wearoffs[type] = nil
				case type
				when :spd_up
					@speed = @start_speed
				end
			end
		end
	end

	def update
		# Player controls
		@controls.each do |k,v|
			v.each do |btn|
				move k  if (Gosu.button_down? btn)
			end
		end
		# Handle effect wearoffs
		handle_effect_wearoffs
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
			dir = -1  unless (@y - (@size[:h] / 2) <= @playing_area.y)
		when :down
			dir = 1   unless (@y + (@size[:h] / 2) >= @playing_area.y + @playing_area.h)
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

