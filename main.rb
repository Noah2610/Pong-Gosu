
require 'gosu'
require './src/Screen'
require './src/PlayingArea'
require './src/Pad'
require './src/Ball'
require './src/Panel'

$screen_res = {
	w: 800,
	h: 520
}

$controls = [
	{
		up:    [Gosu::KB_W],
		down:  [Gosu::KB_S]
	},
	{
		up:    [Gosu::KB_UP, Gosu::KB_K],
		down:  [Gosu::KB_DOWN, Gosu::KB_J]
	}
]

class Game < Gosu::Window
	def initialize
		@screen = Screen.new w: $screen_res[:w], h: $screen_res[:h]
		super @screen.w, @screen.h
		self.caption = "Pong!"
	end

	def button_down id
		case id
		when Gosu::KB_Q
			close
		end
	end

	def update
		# Update Ball(s)
		@screen.playing_area.balls.each &:update

		# Player / Pad controls
		@screen.playing_area.players.each do |p|
			p.controls.each do |k,v|
				v.each do |btn|
					p.move k  if (Gosu.button_down? btn)
				end
			end
		end
	end

	def draw
		@screen.draw
	end
end

game = Game.new
game.show

