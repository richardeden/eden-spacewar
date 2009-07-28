require 'rubygems'
require 'gosu'

class Asteroid
  attr_accessor :x, :y, :angle
  
  def initialize(window)
    @image = Gosu::Image::load_tiles(window, "images/asteroids.png", 49, 50, false)
    @x = rand(800)
    @y = 0
    @angle = rand(360.0)
  end
  
  def update
    @x += Gosu::offset_x(@angle, 0.5)
    @y += Gosu::offset_y(@angle, 0.5)
  end
  
  def offscreen?
    if @x > 800 or @x < 0 or @y > 800 or @y < 0
      return true
    end
    false
  end
  
  def draw
      img = @image[Gosu::milliseconds / 100 % @image.size]
      img.draw((@x - img.width / 2.0), (@y - img.height / 2.0), 0, 1, 1)
  end
  
end