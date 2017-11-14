
require 'gosu'
require 'byebug'
require './src/Buttons'
require './src/Menu'
require './src/Screen'
require './src/PlayingArea'
require './src/Ball'
require './src/Panel'
require './src/Pad'
require './src/Player'
require './src/Cpu'
#require './src/CpuPad'

SCREEN_RES = {
	w: 840,
	h: 520
}

DEFAULT_CONTROLS = [
	{
		up:    [Gosu::KB_W, Gosu::KB_D],
		down:  [Gosu::KB_S],
	},
	{
		up:    [Gosu::KB_UP, Gosu::KB_K],
		down:  [Gosu::KB_DOWN, Gosu::KB_J]
	}
]

CONTROLS = DEFAULT_CONTROLS

PAUSE_BUTTON = [Gosu::KB_P, Gosu::KB_ESCAPE]

$ball_start_speed = {
	x: 4,
	y: 0
}

$ball_start_dir = {
	x: 1,
	y: 0
}

$ball_speed_incr = {
	x: 0.5,
	y: 1
}

$ball_delay = 3.0

PAD_SPEED = 4

PAD_SIZE = {
	w: 16,
	h: 64
}


def btn_id_to_char id
	ret = Gosu.button_id_to_char(id).upcase
	if (ret == "")
		case id
		when Gosu::KB_UP
			ret = "/\\"
		when Gosu::KB_DOWN
			ret = "\\/"
		when Gosu::KB_LEFT
			ret = "<"
		when Gosu::KB_RIGHT
			ret = ">"
		else
			ret = "?"
		end
	end
	return ret
end


class Game < Gosu::Window
	def initialize
		@screen = Screen.new w: SCREEN_RES[:w], h: SCREEN_RES[:h]
		super @screen.w, @screen.h
		self.caption = "Pong!"
	end

	def button_down id
		case id
		when Gosu::KB_ESCAPE
			close
		else
			@screen.button_down id
		end
	end

	def button_up id
		case id
		when Gosu::MS_LEFT, Gosu::MS_RIGHT, Gosu::MS_MIDDLE
			@screen.menu.has_clicked = false
		end
	end

	def needs_cursor?
		!$game_running
	end

	def update
		@screen.update  unless ($game_paused)
	end

	def draw
		@screen.draw
	end
end

$game_running = false
$game_paused = false
$game = Game.new
$game.show

