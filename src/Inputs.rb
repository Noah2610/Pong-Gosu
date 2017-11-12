
class Input < Gosu::TextInput
	def initialize args
		init args  if (defined? init)
	end

	def button_down id
		puts id
	end

	def update
	end

	def draw
	end
end

