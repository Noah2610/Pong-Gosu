#!/bin/env ruby

require 'gosu'
require 'yaml'
require 'awesome_print'
require 'byebug'
require './src/Settings'
require './src/Buttons'
require './src/Menu'
require './src/Screen'
require './src/PlayingArea'
require './src/Ball'
require './src/Panel'
require './src/Pad'
require './src/Player'
require './src/Cpu'


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
		@screen = Screen.new w: $settings.resolution[:w], h: $settings.resolution[:h]
		super @screen.w, @screen.h
		self.caption = "Pong!"
	end

	def button_down id
		close  if (id == Gosu::KB_ESCAPE && Gosu.button_down?(Gosu::KB_LEFT_SHIFT))
		@screen.button_down id
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

$settings = Settings.new "./settings.yml"
$game_running = false
$game_paused = false
$game = Game.new
$game.show

