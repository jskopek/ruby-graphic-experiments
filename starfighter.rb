require 'gosu'

class GameWindow < Gosu::Window
	WIDTH = 1200
	HEIGHT = 900

	def initialize
		super(WIDTH, HEIGHT, false)
		self.caption = 'Hello world'
		@starfighter = StarFighter.new self
	end

	def draw
		@starfighter.draw
	end

	def update
		if button_down? Gosu::KbUp
			@starfighter.accelerate
		end
		if button_down? Gosu::KbLeft
			@starfighter.rotate -3
		end
		if button_down? Gosu::KbRight
			@starfighter.rotate 3
		end
		@starfighter.move
	end

	def button_down(id)
		if id == Gosu::KbEscape
			exit
		end
	end
end

class StarFighter
	def initialize(window)
		@x, @y, @rotation = 100, 100, 0
		@window = window
		@acceleration = 0
		@image = Gosu::Image.new window, 'media/Starfighter.png'
	end

	def accelerate
		@acceleration = 10
	end

	def move
		@x += Gosu::offset_x(@rotation, @acceleration)
		@y += Gosu::offset_y(@rotation, @acceleration)
		@acceleration *= 0.995

		@x %= @window.width
		@y %= @window.height
	end

	def rotate angle_change
		@rotation += angle_change
		@rotation %= 360
	end

	def draw
		@image.draw_rot(@x, @y, 0, @rotation)
	end
end

window = GameWindow.new
window.show