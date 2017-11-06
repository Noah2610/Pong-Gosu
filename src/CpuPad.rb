
class CpuPad
	attr_reader :id, :x,:y, :controls, :size
	attr_accessor :score

	def initialize args
		@id = args[:id]
		@playing_area = args[:playing_area]
		@y = (@playing_area.h / 2)
		@color = Gosu::Color.argb 0xff_444444
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

		@@step = 4
		@step = @@step
		@@move_padding = @size[:h] / 2
	end

	def find_ball
		closest = {
			ball: nil,
			dist: nil
		}
		@playing_area.balls.each do |ball|
			dist = Float::INFINITY
			case @id
			when 0
				dist = ball.x
			when 1
				dist = @x - ball.x
			end
			if (closest[:dist].nil? || dist < closest[:dist])
				closest = {
					ball: ball,
					dist: dist
				}
			end
		end
		return closest[:ball]
	end

	def move id
		case id
		when :up
			@y -= @step  unless (@y - (@size[:h] / 2) <= 0)
		when :down
			@y += @step  unless (@y + (@size[:h] / 2) >= @playing_area.h)
		end
	end

	def update
		# Find closest Ball
		ball = find_ball
		return  if ball.nil?
		# TODO: vvv make this better vvv
		if ((ball.speed[:x] - BALL_START_SPEED_X) % 2 == 0)
			@step = @@step + ball.speed[:x] / 2
		elsif (ball.speed[:x] == BALL_START_SPEED_X)
			@step = @@step
		end
		unless (ball.nil?)
			diff = ball.y - @y
			return  if (diff.abs < @@move_padding)
			if    (diff < 0)
				move :up
			elsif (diff > 0)
				move :down
			end
		end
	end

	def draw
		Gosu.draw_rect (@x - (@size[:w] / 2)), (@y - (@size[:h] / 2)), @size[:w], @size[:h], @color
	end
end

