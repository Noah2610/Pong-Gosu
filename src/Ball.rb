
class Ball
	def initialize args
		@playing_area = args[:playing_area]
		@x = @playing_area.w / 2
		@y = @playing_area.h / 2
		@x = args[:x]  if (!args[:x].nil?)
		@y = args[:y]  if (!args[:y].nil?)
		@size = 16
		@color = Gosu::Color.argb 0xff_000000
		@@speed_incr = 1
		@@start_speed = {
			x: 4,
			y: 0
		}
		@speed = @@start_speed.dup
	end

	def reset dir=:right
		@x = @playing_area.w / 2
		@y = @playing_area.h / 2
		@speed = @@start_speed.dup
		case dir
		when :left
			@speed[:x] = @speed[:x].abs * -1
		when :right
			@speed[:x] = @speed[:x].abs
		end
	end

	def collision
		# Collision checking - Players / Pads
		@playing_area.players.each do |p|
			if    (((@x + @size / 2) >= (p.x - p.size[:w] / 2) && (@x - @size / 2) < (p.x + p.size[:w] / 2)) &&
				    ((@y + @size / 2) >= (p.y - p.size[:h] / 2) && (@y - @size / 2) < (p.y - p.size[:h] / 4)))
				return {
					target: :player,
					pos: :top,
					id: p.id
				}
			elsif (((@x + @size / 2) >= (p.x - p.size[:w] / 2) && (@x - @size / 2) <= (p.x + p.size[:w] / 2)) &&
						 ((@y + @size / 2) >= (p.y - p.size[:h] / 4) && (@y - @size / 2) <= (p.y + p.size[:h] / 4)))
				return {
					target: :player,
					pos: :center,
					id: p.id
				}
			elsif (((@x + @size / 2) >= (p.x - p.size[:w] / 2) && (@x - @size / 2) <= (p.x + p.size[:w] / 2)) &&
						 ((@y + @size / 2) >= (p.y + p.size[:h] / 4) && (@y - @size / 2) <= (p.y + p.size[:h] / 2)))
				return {
					target: :player,
					pos: :bottom,
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
		@x += @speed[:x]
		@y += @speed[:y]
	end

	def update
		move
		coll = collision
		if (coll)
			# Change direction
			case coll[:target]
			# Player collision
			when :player
				case coll[:id]
				when 0
					@speed[:x] = @speed[:x].abs
					@speed[:x] += (@speed[:x] > 0) ? @@speed_incr : -@@speed_incr
				when 1
					@speed[:x] = @speed[:x].abs * -1
					@speed[:x] += (@speed[:x] > 0) ? @@speed_incr : -@@speed_incr
				end
				# Change y speed
				case coll[:pos]
				when :top
					@speed[:y] -= @@speed_incr
				when :center
				when :bottom
					@speed[:y] += @@speed_incr
				end

			# Border x collision
			when :goal
			# Border y collision
				case coll[:side]
				when :left
					reset :right
					@playing_area.players[1].score += 1
				when :right
					reset :left
					@playing_area.players[0].score += 1
				end

			when :border
				case coll[:side]
				when :bottom
					@speed[:y] = @speed[:y].abs * -1
				when :top
					@speed[:y] = @speed[:y].abs
				end

			end
		end
	end

	def draw
		Gosu.draw_rect (@x - (@size / 2)), (@y - (@size / 2)), @size, @size, @color
	end
end

