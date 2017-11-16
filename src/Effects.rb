
class Effects
	attr_reader :x,:y, :size, :name

	def initialize args
		@playing_area = args[:playing_area]
		@size = 32
		@@default_sprite = Gosu::Image.new "./sprites/default.png"
		@@sprites = {
			spd_up:   Gosu::Image.new("./sprites/spd_up.png"),
			spd_down: Gosu::Image.new("./sprites/spd_down.png"),
		}
		offset = @playing_area.pad_offset
		padding = 32
		@spawn_ranges = {
			x: ((@playing_area.x + offset + padding) .. (@playing_area.x + @playing_area.w - offset - padding)),
			y: ((@playing_area.y + padding) .. (@playing_area.y + @playing_area.h - padding))
		}
		@x = rand(@spawn_ranges[:x])
		@y = rand(@spawn_ranges[:y])

		if (args[:effect].nil?)
			@name = @@sprites.to_a.sample[0]
			@sprite = @@sprites[@name]
		elsif (!@@sprites[args[:effect]].nil?)
			@name = args[:effect]
			@sprite = @@sprites[@name]
		else
			@name = :default
			@sprite = @@default_sprite
		end

		init  if (defined? init)
	end

	def hit pad
		return  if (pad.nil?)
		case @name
		when :spd_up
			pad.add_effect :spd_up
		else
			puts "EFFECT TRIGGERED: #{@name}"
		end
		@playing_area.destroy_effect self
	end

	def draw
		@sprite.draw (@x - @size),(@y - @size), 1
	end
end

