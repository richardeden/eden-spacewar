require 'rubygems'
require 'gosu'

class Asteroid
  attr_accessor :x, :y, :angle, :type
  LARGE_ASTEROID = 1
  SMALL_ASTEROID = 2
  
  def initialize(window, opts={})
    unless opts[:x].nil? && opts[:y].nil?
      @image = Gosu::Image::load_tiles(window, "images/small_asteroids.png", 29, 29, false)
      @x = opts[:x]
      @y = opts[:y]
      @type = SMALL_ASTEROID
    else
      @image = Gosu::Image::load_tiles(window, "images/asteroids.png", 49, 50, false)
      @x = rand(800)
      @y = 0
      @type = LARGE_ASTEROID
    end
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
  
  def collision?(player_x, player_y)
    Gosu::distance(player_x, player_y, @x, @y) < 40 ? true : false
  end
  
  def hit_by_missile?(player)
    player.missiles.each do |missile|
      if @type == LARGE_ASTEROID
        if Gosu::distance(@x, @y, missile.x, missile.y) < 20 
          player.missiles.delete(missile)
          return true
        end
      elsif @type == 2
        if Gosu::distance(@x, @y, missile.x, missile.y) < 5
          player.missiles.delete(missile)
          return true
        end
      end
    end
    false
  end
  
  def draw
    img = @image[Gosu::milliseconds / 100 % @image.size]
    img.draw((@x - img.width / 2.0), (@y - img.height / 2.0), 0, 1, 1)
  end
  
end