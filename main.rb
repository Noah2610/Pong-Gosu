
require 'gosu'
require './src/Screen'
require './src/PlayingArea'
require './src/Ball'
require './src/Panel'
require './src/Pad'
require './src/Player'
require './src/Cpu'
#require './src/CpuPad'

SCREEN_RES = {
	w: 800,
	h: 520
}

CONTROLS = [
	{
		up:    [Gosu::KB_W],
		down:  [Gosu::KB_S]
	},
	{
		up:    [Gosu::KB_UP, Gosu::KB_K],
		down:  [Gosu::KB_DOWN, Gosu::KB_J]
	}
]

BALL_START_SPEED = {
	x: 4,
	y: 0
}

BALL_START_DIR = {
	x: 1,
	y: 0
}

BALL_SPEED_INCR = {
	x: 0.5,
	y: 1
}

class Game < Gosu::Window
	def initialize
		@screen = Screen.new w: SCREEN_RES[:w], h: SCREEN_RES[:h]
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
		@screen.playing_area.update
	end

	def draw
		@screen.draw
	end
end

game = Game.new
game.show

