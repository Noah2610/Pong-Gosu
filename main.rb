
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

valid_buttons = {}
(4..29).to_a.each do |id|
	valid_buttons[id] = nil
end
("A".."Z").to_a.each_with_index do |btn,count|
	valid_buttons[count + 4] = btn
end
valid_buttons[82] = "/\\"  # up
valid_buttons[81] = "\\/"  # down
valid_buttons[80] = "<"    # left
valid_buttons[79] = ">"    # right
VALID_BUTTONS = valid_buttons

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

