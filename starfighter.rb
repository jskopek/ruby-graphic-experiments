require 'gosu'

class GameWindow < Gosu::Window
	WIDTH = 1200
	HEIGHT = 900

	def initialize
		super(WIDTH, HEIGHT, false)
		self.caption = 'Hello world'
		@starfighter = StarFighter.new self
		@bullets = []

		@asteroids = []
		(1..10).each do |i|
			asteroid = Asteroid.new self
			@asteroids.push asteroid
		end
	end

	def draw
		@starfighter.draw
		for bullet in @bullets
			bullet.draw
		end

		for asteroid in @asteroids
			asteroid.draw
		end
		puts "Number of Bullets: #{@bullets.count}"
	end

	def update
		if button_down? Gosu::KbUp
			@starfighter.accelerate 5
		end
		if button_down? Gosu::KbLeft
			@starfighter.rotate -3
		end
		if button_down? Gosu::KbRight
			@starfighter.rotate 3
		end
		if button_down? Gosu::KbSpace
			bullet = Bullet.new self, @starfighter.x, @starfighter.y, @starfighter.rotation
			@bullets.push bullet
		end

		@starfighter.move
		for bullet in @bullets
			bullet.move
			if bullet.is_offscreen?
				@bullets.delete bullet
			end
		end

		for asteroid in @asteroids
			if asteroid.touched? @bullets
				@asteroids.delete asteroid
			end
			asteroid.move
		end
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
	MOVEMENT = 12
	attr_accessor :x
	attr_accessor :y

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
		size = 5
		@window.draw_quad(@x, @y, color, @x + size, @y, color, @x + size, @y + size, color, @x, @y + size, color)
		# puts "Drawing Quad: #{@x} #{@y}"
	end

	def is_offscreen?
		return true if @x < 0 or @x > @window.width or @y < 0 or @y > @window.height else false
	end
end

class Asteroid
	SIZE = 20

	def initialize window
		@x = rand window.width
		@y = rand window.height
		@rotation = rand 360
		@movement = rand 5
		@window = window
	end
	
	def move
		@x += Gosu::offset_x(@rotation, @movement)
		@y += Gosu::offset_y(@rotation, @movement)
		@x %= @window.width
		@y %= @window.height
	end

	def draw
		color = Gosu::Color.new 0x22228888
		@window.draw_quad(@x, @y, color, @x + SIZE, @y, color, @x + SIZE, @y + SIZE, color, @x, @y + SIZE, color)
	end

	def touched? items
		for item in items
			if Gosu::distance(item.x, item.y, @x, @y) < SIZE
				return true
			end
		end
		return false
	end
end




window = GameWindow.new
window.show