require 'rubygems'
require 'gosu'
require 'missile'

class Ship
  attr_accessor :x, :y, :vel_x, :vel_y, :angle, :top_speed, :missiles, :window
  
  def initialize(window, start_x, start_y, player_num)
    @window = window
    set_player_ship(player_num)
    reset(start_x, start_y)
  end
  
  def reset(x, y)
    @x = x
    @y = y
    @vel_x = 0.0
    @vel_y = 0.0
    @angle = 0.0
    @missiles = []
    @top_speed = 5.0
  end
    
  def set_player_ship(num)
    if num == 1
      @ship_image = Gosu::Image::new(@window, "images/player_ship_red.png", false)
    else
      @ship_image = Gosu::Image::new(@window, "images/player_ship_blue.png", false)
    end
  end
  
  def hit_opponent?(opponent_x, opponent_y)
    return false if @missiles.empty?
    @missiles.each do |missile|
      if Gosu::distance(opponent_x, opponent_y, missile.x, missile.y) < 20
        return true
      end
    end
    false
  end

  def turn_left
    @angle -= 4.5
  end
  
  def turn_right
    @angle += 4.5
  end
  
  
  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.1)
    @vel_y += Gosu::offset_y(@angle, 0.1)
  end
  
  def move_ship
    @x += @vel_x
    @y += @vel_y
    
    #make sure we don't go off the screen
    @x %= 800
    @y %= 600
  end
  
  def fire
    unless @missiles.size >= 10
      if @missiles.size > 0
        if (Time.now - @missiles.last.time_fired) > 1
          @missiles << Missile.new(@x + 20.0, @y, @angle, @window)
        end
      else
        @missiles << Missile.new(@x + 20.0, @y, @angle, @window)
      end
    end
  end
  
  def firing?
    @missiles.empty? ? false : true      
  end
  
  def update_missiles
    @missiles.each do |missile|
      if missile.offscreen?
        @missiles.delete(missile)
      else
        missile.update
      end
    end
  end

  def draw
    if firing?
      update_missiles
    end
    @ship_image.draw_rot(@x, @y, 1, @angle)
  end
  
end