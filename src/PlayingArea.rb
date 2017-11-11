
class PlayingArea
	attr_reader :w, :h, :pads, :balls

	def initialize args
		@w = args[:w]
		@h = args[:h]
		@pads = [
			Player.new(id: 0, playing_area: self),
			Cpu.new(id: 1, playing_area: self)
		]
		@ball_delay = 3
		@balls = []
		@new_ball_delay_sec = 20 + @ball_delay
		@new_ball_at = nil
	end

	def set_pad args
		case args[:type]
		when :player
			@pads[args[:id]] = Player.new id: args[:id], playing_area: self
		when :cpu
			@pads[args[:id]] = Cpu.new id: args[:id], playing_area: self
		end
	end

	def set_control args
		@pads.each do |p|
			if (p.class == Player && p.id == args[:id])
				return p.update_control dir: args[:dir], key: args[:key]
			end
		end
		return nil
	end

	def player id
		@pads.each do |p|
			if (id == p.id)
				return p
			end
		end
		return nil
	end

	def new_ball
		highest = {}
		@pads.each do |p|
			side = nil
			case p.id
			when 0
				side = :left
			when 1
				side = :right
			end
			if ((highest.empty? || p.score > highest[:score]) || (!highest.empty? && p.score == highest[:score] && rand(2) == 0))
				highest = { side: side, score: p.score }
			end
		end

		@balls << Ball.new(playing_area: self, side: highest[:side], delay: @ball_delay)
	end

	def handle_new_ball
		return
		if (!@new_ball_at.nil? && @new_ball_at < Time.now)
			new_ball  unless (@new_ball_at.nil?)
			@new_ball_at = Time.now + @new_ball_delay_sec
		end
	end

	def reset side = :right
		@balls.clear
		@balls << Ball.new(playing_area: self, side: side, delay: @ball_delay)
		@new_ball_at = Time.now + @new_ball_delay_sec
	end

	def goal side
		case side
		when :left
			reset :right
			@pads.each do |p|
				if (p.id == 1)
					p.score += 1
				end
			end
		when :right
			reset :left
			@pads.each do |p|
				if (p.id == 0)
					p.score += 1
				end
			end
		end
	end

	def start_game
		$game_running = true
		new_ball
	end

	def button_down id
		# Check for pause button
		PAUSE_BUTTON.each do |pbtn|
			if (id == pbtn)
				$game_paused = !$game_paused
				if (!$game_paused)
					@balls.each do |ball|
						ball.add_delay
					end
				end
				return
			end
		end
	end

	def update
		@pads.each &:update
		if ($game_running)
			handle_new_ball
			@balls.each &:update
		end
	end

	def draw
		# Draw Background
		color = Gosu::Color.argb(0xff_ffffff)
		Gosu.draw_rect 0,0, @w,@h, color

		# Draw Players / Pads
		@pads.each &:draw

		# Draw Ball(s)
		@balls.each &:draw  if ($game_running)
	end
end

