
class PlayingArea
	attr_reader :w,:h, :x,:y, :pads, :balls, :screen, :pad_offset, :effects
	attr_accessor :demo_game

	def initialize args
		@screen = args[:screen]
		@w = args[:w]
		@h = args[:h]
		@x = args[:x] || 0
		@y = args[:y] || 0
		@pad_offset = 32
		@pads = [
			Player.new(id: 0, playing_area: self),
			Cpu.new(id: 1, playing_area: self)
		]
		@balls = []
		@new_ball_delay_sec = $settings.ball[:multiple_balls_delay] + $settings.ball[:delay]
		@new_ball_at = nil
		@demo_game = false
		@inputs_paused = [
			ContinueGameButton.new(
				playing_area:     self,
				x:                (@w / 2),
				y:                (@h / 4 * 0.75),
				font_label_size:  64,
				label_distance:   16
			),
			BackToMenuButton.new(
				playing_area:     self,
				x:                (@w / 2),
				y:                (@h / 4 * 1.1)
			),
			CloseButton.new(
				x:     (@screen.w - 32),
				y:     32,
				size:  { w: 32, h: 32 }
			)
		]

		puts $settings.effect.to_s
		@new_effect_at = Time.now + $settings.effect[:spawn_rate]

		@effects = []
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

	def cpus_demo_move pattern
		cpus = []
		@pads.each do |p|
			cpus << p  if (p.is_a? Cpu)
		end
		case pattern
		when :up_down
			cpus.each do |cpu|
				case cpu.demo_movement
				when 0
					cpu.demo_movement = rand(2) == 0 ? -1 : 1
				when -1
					ret = cpu.move :up
				when 1
					ret = cpu.move :down
				end
				if (ret == :border_collision)
					cpu.demo_movement *= -1
				end
			end
		end
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

		@balls << Ball.new(playing_area: self, side: highest[:side], delay: $ball_delay.dup)
	end

	def handle_new_ball
		if (!@new_ball_at.nil? && @new_ball_at < Time.now)
			new_ball  unless (@new_ball_at.nil?)
			@new_ball_at = Time.now + @new_ball_delay_sec
		end
	end

	def reset side = :right
		@balls.clear
		@balls << Ball.new(playing_area: self, side: side, delay: $settings.ball[:delay])
		@new_ball_at = Time.now + @new_ball_delay_sec
	end

	def ball_reset
		@balls.clear
		@balls << Ball.new(playing_area: self, side: ((rand(2) == 0) ? :left : :right), delay: $settings.ball[:delay])  if (@demo_game)
	end

	def goal side = ((rand(2) == 0) ? :left : :right)
		case side
		when :left
			reset :right
			player(1).score += 1
		when :right
			reset :left
			player(0).score += 1
		end
	end

	def start_game
		$needs_cursor = false
		$game_running = true
		@balls.clear
		new_ball
	end

	def toggle_pause_game state = nil
		case state
		when :pause
			$game_paused = true
		when :unpause
			$game_paused = false
		when nil
			$game_paused = !$game_paused
		end
		case $game_paused
		when true   # game was PAUSED
			$needs_cursor = true
			@inputs_paused.each &:show

		when false  # game was UNPAUSED
			$needs_cursor = false
			@inputs_paused.each &:hide
			@balls.each do |ball|
				ball.add_delay
			end
		end
	end

	def to_menu
		toggle_pause_game :unpause
		@balls.clear
		@pads.each { |p| p.score = 0 }
		$game_running = false
	end

	def handle_effects
		if (Time.now > @new_effect_at)
			@effects << Effects.new(
				playing_area: self,
				effect:       :spd_up
			)
			@new_effect_at = Time.now + $settings.effect[:spawn_rate]
		end
	end

	def destroy_effect effect
		@effects.delete effect
	end

	def button_down id
		# Check for pause button
		$settings.pause_button.each do |pbtn|
			if (id == pbtn)
				toggle_pause_game
				return
			end
		end
	end

	def click
		@inputs_paused.each &:click
	end

	def update
		unless ($game_paused)
			if ($game_running)
				handle_new_ball  if ($settings.ball[:multiple_balls_delay] > 0)
				handle_effects   unless ($settings.effect[:spawn_rate] == 0)
			end
			@pads.each &:update
			@balls.each &:update
		end
		# Update inputs (when game is paused)
		@inputs_paused.each &:update
	end

	def draw
		# Draw Background
		color = Gosu::Color.argb(0xff_ffffff)
		Gosu.draw_rect @x,@y, @w,@h, color

		# Draw Players / Pads
		@pads.each &:draw

		# Draw Ball(s)
		@balls.each &:draw  if ($game_running || @demo_game)

		# Draw inputs (when game is paused)
		@inputs_paused.each &:draw

		# Draw sprites (Effects)
		@effects.each &:draw
	end
end

