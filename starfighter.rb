require 'gosu'

class GameWindow < Gosu::Window
	WIDTH = 1200
	HEIGHT = 900

	def initialize
		super(WIDTH, HEIGHT, false)
		self.caption = 'Hello world'
		@starfighter = StarFighter.new self
		@bullet = nil
	end

	def draw
		@starfighter.draw
		@bullet.draw if @bullet
	end

	def update
		if button_down? Gosu::KbUp
			@starfighter.accelerate 15
		end
		if button_down? Gosu::KbLeft
			@starfighter.rotate -3
		end
		if button_down? Gosu::KbRight
			@starfighter.rotate 3
		end
		if button_down? Gosu::KbSpace
			@bullet = Bullet.new self, @starfighter.x, @starfighter.y, @starfighter.rotation
		end

		@starfighter.move
		@bullet.move if @bullet
	end

	def button_down(id)
		exit if id == Gosu::KbEscape
	end
end

class StarFighter
	attr_accessor :x
	attr_accessor :y
	attr_accessor :rotation

	def initialize(window)
		@x, @y, @rotation = 100, 100, 0
		@movement_x, @movement_y = 0, 0
		@window = window
		@image = Gosu::Image.new window, 'media/Starfighter.png'
	end

	def accelerate acceleration
		@movement_x = Gosu::offset_x(@rotation, acceleration)
		@movement_y = Gosu::offset_y(@rotation, acceleration)
	end

	def move
		@x += @movement_x
		@y += @movement_y
		@movement_x *= 0.995
		@movement_y *= 0.995

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

class Bullet
	MOVEMENT = 50

	def initialize window, x, y, rotation
		@x, @y, @rotation = x, y, rotation
		@window = window
	end

	def move
		@x += Gosu::offset_x(@rotation, MOVEMENT)
		@y += Gosu::offset_y(@rotation, MOVEMENT)
	end

	def draw
		color = Gosu::Color.new 0xffff8888
		@window.draw_quad(@x, @y, color, @x + 5, @y, color, @x + 5, @y + 5, color, @x, @y + 5, color)
		# puts "Drawing Quad: #{@x} #{@y}"
	end
end




window = GameWindow.new
window.show