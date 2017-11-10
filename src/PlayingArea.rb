
class PlayingArea
	attr_reader :w, :h, :pads, :balls

	def initialize args
		@w = args[:w]
		@h = args[:h]
		@pads = [
			Player.new(id: 0, playing_area: self),
			Player.new(id: 1, playing_area: self),
			#Cpu.new(id: 0, playing_area: self)
			#Cpu.new(id: 1, playing_area: self)
		]
		@ball_delay = 3
		@balls = [
			Ball.new(playing_area: self, side: (rand(2) == 0 ? :left : :right), delay: @ball_delay)
		]
		@new_ball_delay_sec = 20 + @ball_delay
		@new_ball_at = nil
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

	def update
		handle_new_ball

		# Update Cpu Players
		@pads.each &:update
		# Update Balls
		@balls.each &:update

		# Player controls
		@pads.each do |p|
			next  if (p.class == Cpu)
			p.controls.each do |k,v|
				v.each do |btn|
					p.move k  if (Gosu.button_down? btn)
				end
			end
		end
	end

	def draw
		# Draw Background
		color = Gosu::Color.argb(0xff_ffffff)
		Gosu.draw_rect 0,0, @w,@h, color

		# Draw Players / Pads
		@pads.each &:draw

		# Draw Ball(s)
		@balls.each &:draw
	end
end

