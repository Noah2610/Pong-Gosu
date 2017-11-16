
# source of deep_merge:
# https://stackoverflow.com/a/30225093
=begin
class ::Hash
	def deep_merge(second)
		merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : Array === v1 && Array === v2 ? v1 | v2 : [:undefined, nil, :nil].include?(v2) ? v1 : v2  }
		self.merge(second.to_h, &merger)
	end
end
=end
# source of deep_merge:
# https://stackoverflow.com/a/9381776
class ::Hash
	def deep_merge(second)
		merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2  }
		self.merge(second, &merger)
	end
end

class Settings
	attr_reader :settings

	def initialize filename
		filename_default = "./settings_default.yml"
		load_settings filename
		load_settings filename_default, true
		@settings = @settings_default.deep_merge @settings
	end

	def save filename = "settings_out.yml"
		file = File.new filename, "w"
		ret = !!file.write("#{parse_to_strings(@settings).to_yaml}...")
		file.close
		return ret
	end

	def set key, val, args = nil
		case key
		when :resolution
			case args[:axis]
			when :w, :width, :x
				@settings[:general][:resolution][:width] = val
			when :h, :height, :y
				@settings[:general][:resolution][:height] = val
			when nil
				@settings[:general][:resolution] = val
			end
			return @settings[:general][:resolution]

		when :controls
			unless (args[:dir].nil?)
				case args[:id]
				when 0
					@settings[:controls][:pad_one][args[:dir]] = val
					return @settings[:controls][:pad_one]
				when 1
					@settings[:controls][:pad_two][args[:dir]] = val
					return @settings[:controls][:pad_two]
				when nil
					@settings[:controls][:pad_one] = val
					return @settings[:controls]
				end
			else
				return false
			end

		when :ball_delay
			@settings[:ball][:spawn_delay] = val
			return @settings[:ball][:spawn_delay]

		when :ball_base_speed
			case args[:axis]
			when :x
				@settings[:ball][:starting_speed][:x] = val
			when :y
				@settings[:ball][:starting_speed][:y] = val
			when nil
				@settings[:ball][:starting_speed] = val
			end
			return @settings[:ball][:starting_speed]

		when :ball_start_dir
			case args[:axis]
			when :x
				@settings[:ball][:starting_direction][:x] = val
			when :y
				@settings[:ball][:starting_direction][:y] = val
			when nil
				@settings[:ball][:starting_direction] = val
			end
			return @settings[:ball][:starting_direction]

		when :ball_speed_incr
			case args[:axis]
			when :x
				@settings[:ball][:speed_increment][:x] = val
			when :y
				@settings[:ball][:speed_increment][:y] = val
			when nil
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

	def load_settings file, default = false
		data = YAML.load_file(file)
		case default
		when false
			@settings = parse_to_symbols data
		when true
			@settings_default = parse_to_symbols data
		end
	end

	def parse_to_symbols data
		ret = nil
		# Hash
		if (data.is_a? Hash)
			ret = {}
			data.each do |k,v|
				key = k.to_sym
				ret[key] = v
				ret[key] = parse_to_symbols ret[key]
			end
		# Array
		elsif (data.is_a? Array)
			ret = []
			data.each do |v|
				ret << parse_to_symbols(v)
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

	def parse_to_strings data, is_control = false
		ret = nil
		# Hash
		if (data.is_a? Hash)
			ret = {}
			data.each do |k,v|
				is_control = true  if (k.to_sym == :controls)
				key = k.to_s
				ret[key] = v
				ret[key] = parse_to_strings ret[key], is_control
			end
		# Array
		elsif (data.is_a? Array)
			ret = []
			data.each do |v|
				ret << parse_to_strings(v, is_control)
			end
		# Integer || Float
		elsif (data.is_a?(Integer) || data.is_a?(Float))
			if (is_control)
				char = Gosu.button_id_to_char data
				if (char != "")
					ret = "Key:#{char.upcase}"
				elsif (char == "")
					case data
					when Gosu::KB_UP
						ret = "Key:UP"
					when Gosu::KB_DOWN
						ret = "Key:DOWN"
					when Gosu::KB_LEFT
						ret = "Key:LEFT"
					when Gosu::KB_RIGHT
						ret = "Key:RIGHT"
					else
						ret = data
					end
				end
			else
				ret = data
			end
		# String
		elsif (data.is_a? String)
			ret = data
		# Symbol
		elsif (data.is_a? Symbol)
			ret = data.to_s
		end
		return ret
	end
end

