#!/bin/env ruby

require 'gosu'
require 'yaml'
require 'awesome_print'
#require 'byebug'
require './src/Buttons'
require './src/Menu'
require './src/Screen'
require './src/PlayingArea'
require './src/Ball'
require './src/Panel'
require './src/Pad'
require './src/Player'
require './src/Cpu'

class Settings
	attr_reader :settings

	def initialize file
		@file = load_settings file
	end

	def set key, val, args = nil
		case key
		when :ball_delay
			@settings[:ball][:spawn_delay] = val
			return @settings[:ball][:spawn_delay]

		when :ball_base_speed
			case args[:axis]
			when :x
				@settings[:ball][:starting_speed][:x] = val
			when :y
				@settings[:ball][:starting_speed][:y] = val
			else
				@settings[:ball][:starting_speed] = val
			end
			return @settings[:ball][:starting_speed]

		when :ball_start_dir
			case args[:axis]
			when :x
				@settings[:ball][:starting_direction][:x] = val
			when :y
				@settings[:ball][:starting_direction][:y] = val
			else
				@settings[:ball][:starting_direction] = val
			end
			return @settings[:ball][:starting_direction]

		when :ball_speed_incr
			case args[:axis]
			when :x
				@settings[:ball][:speed_increment][:x] = val
			when :y
				@settings[:ball][:speed_increment][:y] = val
			else
				@settings[:ball][:speed_increment] = val
			end
			return @settings[:ball][:speed_increment]

		when :multiple_balls_delay
			@settings[:general][:multiple_balls_delay] = val
			return @settings[:general][:multiple_balls_delay]

		end
	end

	def resolution
		return {
			w: @settings[:general][:resolution][:width],
			h: @settings[:general][:resolution][:height]
		}
	end

	def pad
		case @settings[:pad][:speed_increment]
		when 0
			speed_incr = false
		else
			speed_incr = true
		end
		return {
			base_speed: @settings[:pad][:speed],
			size:       {
				w: @settings[:pad][:size][:width],
				h: @settings[:pad][:size][:height]
			},
			speed_incr: speed_incr,
			controls:   [
				@settings[:controls][:pad_one].dup,
				@settings[:controls][:pad_two].dup
			]
		}
	end

	def ball
		return {
			size:                 @settings[:ball][:size],
			base_speed:           @settings[:ball][:starting_speed].dup,
			start_dir:            @settings[:ball][:starting_direction].dup,
			speed_incr:           @settings[:ball][:speed_increment].dup,
			delay:                @settings[:ball][:spawn_delay],
			multiple_balls_delay: @settings[:general][:multiple_balls_delay]
		}
	end

	def pause_button
		return @settings[:controls][:pause_button].dup
	end

	def load_settings file
		data = YAML.load_file(file)
		@settings = parse_settings data
	end

	def parse_settings data
		ret = nil
		# Hash
		if (data.is_a? Hash)
			ret = {}
			data.each do |k,v|
				key = k.to_sym
				ret[key] = v
				ret[key] = parse_settings ret[key]
			end

		# Array
		elsif (data.is_a? Array)
			ret = []
			data.each do |v|
				ret << parse_settings(v)
			end

		# Integer || Float
		elsif (data.is_a?(Integer) || data.is_a?(Float))
			ret = data

		# String
		elsif (data.is_a? String)
			if (data[0..3] == "Key:")
				ret = Gosu.char_to_button_id data[4..-1]
			else
				ret = data.to_sym
			end
		end
		return ret
	end
end

settings_file = "./settings.yml"
$settings = Settings.new settings_file
ap $settings.settings


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

