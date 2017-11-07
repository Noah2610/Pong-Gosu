
class Ball
	attr_reader :x, :y, :speed, :reset_time, :dir

	def initialize args
		@playing_area = args[:playing_area]
		@x = @playing_area.w / 2
		@y = @playing_area.h / 2
		@x = args[:x]  if (!args[:x].nil?)
		@y = args[:y]  if (!args[:y].nil?)
		@size = 16
		@color = Gosu::Color.argb 0xff_000000
		@@speed_incr = BALL_SPEED_INCR
		@@start_speed = BALL_START_SPEED
		@speed = @@start_speed.dup
		@delay = args[:delay].nil? ? 0 : args[:delay]
		@@timeout = 3
		@reset_time = (@delay == 0) ? (Time.now + @@timeout) : (Time.now + @delay)
		@@samples = {
			pad_hit: Gosu::Sample.new("./samples/pad_hit.ogg")
		}
		@dir = BALL_START_DIR.dup
		@last_pad_hit = -1
	end

	def reset dir = :right
		@reset_time = Time.now + @@timeout
		@x = @playing_area.w / 2
		@y = @playing_area.h / 2
		@speed = @@start_speed.dup
		@last_pad_hit = -1
		case dir
		when :left
			@dir[:x] = -1
			@dir[:y] = BALL_START_DIR[:y] * (rand(2) == 0 ? 1 : -1)
		when :right
			@dir[:x] = 1
			@dir[:y] = BALL_START_DIR[:y] * (rand(2) == 0 ? 1 : -1)
		end
	end

	def collision
		# Collision checking - Players / Pads
		Array.new.concat(@playing_area.players,@playing_area.cpu_players).each do |p|
			if    (((@x + @size / 2) >= (p.x - p.size[:w] / 2) && (@x - @size / 2) <= (p.x + p.size[:w] / 2)) &&
				     ((@y + @size / 2) >= (p.y - p.size[:h] / 2) && (@y + @size / 2) <= (p.y - p.size[:h] / 4)))
				return {
					target: :player,
					pos: :top,
					id: p.id
				}
			elsif (((@x + @size / 2) >= (p.x - p.size[:w] / 2) && (@x - @size / 2) <= (p.x + p.size[:w] / 2)) &&
						 ((@y - @size / 2) >= (p.y + p.size[:h] / 4) && (@y - @size / 2) <= (p.y + p.size[:h] / 2)))
				return {
					target: :player,
					pos: :bottom,
					id: p.id
				}
			elsif (((@x) >= (p.x - p.size[:w] / 2) && (@x - @size / 2) <= (p.x + p.size[:w] / 2)) &&
						 ((@y) >= (p.y - p.size[:h] / 4) && (@y - @size / 2) <= (p.y + p.size[:h] / 4)))
				return {
					target: :player,
					pos: :center,
					id: p.id
				}
			end
		end

		# Collision checking - Goals (x)
		if    ((@x + @size / 2) > @playing_area.w)
			return {
				target: :goal,
				side: :right
			}
		elsif ((@x - @size / 2) < 0)
			return {
				target: :goal,
				side: :left
			}
		end

		# Collision checking - Borders (y)
		if    ((@y + @size / 2) > @playing_area.h)
			return {
				target: :border,
				side: :bottom
			}
		elsif ((@y - @size / 2) < 0)
			return {
				target: :border,
				side: :top
			}
		end

		return false
	end

	def move
		# Start moving after reset
		return  if (Time.now < @reset_time)
		puts @speed.to_s
		@speed[:x].floor.times do |n|
			@x += 1 * @dir[:x]
		end
		@speed[:y].floor.times do |n|
			@y += 1 * @dir[:y]
		end
	end

	def update
		move
		coll = collision
		if (coll)
			case coll[:target]
			# Player collision
			when :player
				case coll[:id]
				when 0
					return  if (@last_pad_hit == 0)
					@speed[:x] += @@speed_incr[:x]
					@dir[:x] = 1
					@last_pad_hit = 0
				when 1
					return  if (@last_pad_hit == 1)
					@speed[:x] += @@speed_incr[:x]
					@dir[:x] = -1
					@last_pad_hit = 1
				end
				# Play sample
				@@samples[:pad_hit].play 0.5, 2
				# Change y speed
				case coll[:pos]
				when :top
					case @dir[:y]
					when 0
						@speed[:y] = @@speed_incr[:y]
						@dir[:y] = -1
					when 1
						@speed[:y] -= @@speed_incr[:y]
						if (@speed[:y] < 1)
							@speed[:y] = 0
							@dir[:y] = 0
						end
					when -1
						@speed[:y] += @@speed_incr[:y]
					end
				when :center
				when :bottom
					case @dir[:y]
					when 0
						@speed[:y] = @@speed_incr[:y]
						@dir[:y] = 1
					when -1
						@speed[:y] -= @@speed_incr[:y]
						if (@speed[:y] < 1)
							@speed[:y] = 0
							@dir[:y] = 0
						end
					when 1
						@speed[:y] += @@speed_incr[:y]
					end
				end

			when :goal
				case coll[:side]
				when :left
					reset :right
					found = false
					@playing_area.players.each do |p|
						if (p.id == 1)
							p.score += 1
							found = true
						end
					end
					@playing_area.cpu_players.each do |p|
						if (p.id == 1)
							p.score += 1
						end
					end  unless found
				when :right
					reset :left
					@playing_area.players.each do |p|
						if (p.id == 0)
							p.score += 1
							found = true
						end
					end
					@playing_area.cpu_players.each do |p|
						if (p.id == 0)
							p.score += 1
						end
					end  unless found
				end

			when :border
				case coll[:side]
				when :bottom
					@dir[:y] = -1
				when :top
					@dir[:y] = 1
				end

			end
		end
	end

	def draw
		# Draw Ball
		Gosu.draw_rect (@x - (@size / 2)), (@y - (@size / 2)), @size, @size, @color
	end
end

