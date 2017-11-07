
class PlayingArea
	attr_reader :w, :h, :pads, :balls

	def initialize args
		@w = args[:w]
		@h = args[:h]
		@pads = [
			#Player.new(id: 0, playing_area: self)
			Player.new(id: 1, playing_area: self),
			Cpu.new(id: 0, playing_area: self),
			#Cpu.new(id: 1, playing_area: self)
		]
		@balls = [
			Ball.new(playing_area: self)
		]
	end

	def update
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

