require 'rubygems'
require 'gosu'

class Ship
  attr_accessor :x, :y, :vel_x, :vel_y, :angle, :acceleration, :thrust_left, :thrust_right
  attr_accessor :missile_x, :missile_y
  
  def initialize(window, start_x, start_y, player_num)
    set_player_ship(window, player_num)
    @missile = Gosu::Image::new(window, "images/missile.png", false)
    @missile_x = 0.0
    @missile_y = 0.0
    @missile_angle = 0.0
    @x = start_x
    @y = start_y
    @vel_x = 0.0
    @vel_y = 0.0
    @angle = 0.0
    @thrust_left = 0.0
    @thrust_right = 0.0
    @firing = false
    @acceleration = 0.1
  end
  
  def player_hit?(missile_x, missile_y)
    if Gosu::distance(@x, @y, missile_x, missile_y) < 35
      return true
    end
    false
  end
  
  def set_player_ship(window, num)
    if num == 1
      @ship_image = Gosu::Image::new(window, "images/player_ship_red.png", false)
    else
      @ship_image = Gosu::Image::new(window, "images/player_ship_blue.png", false)
    end
  end
  
  def reset_missile
    @firing = false
    @missile_x = 0.0
    @missile_y = 0.0
    @missile_angle = 0.0
  end
  
  def turn_left
    @angle -= 4.5
  end
  
  def turn_right
    @angle += 4.5
  end
  
  def thrust_down
    if @vel_x > 0.2 && @vel_y > 0.2
      @vel_x *= 0.95
      @vel_y *= 0.95
    end
  end
  
  def accelerate
    if @acceleration < 2.0
      @acceleration = @acceleration + 0.1
    else
      @acceleration = 2.0
    end
    @vel_x += Gosu::offset_x(@angle, 0.1)
    @vel_y += Gosu::offset_y(@angle, 0.1)
  end
  
  def move_ship
    @x += @vel_x
    @y += @vel_y
  end
  
  def fire
    @firing = true
    @missile_angle = @angle
    @missile_x = @x + 20.0
    @missile_y = @y
  end
  
  def firing?
    @firing
  end
  
  def update_missile
    @missile_x += Gosu::offset_x(@missile_angle, 4.0)
    @missile_y += Gosu::offset_y(@missile_angle, 4.0)
    if @missile_x > 800 or @missile_x < 0 or @missile_y > 800 or @missile_y < 0
      reset_missile
    end
  end

  def draw
    if @firing
      update_missile
      @missile.draw_rot(@missile_x, @missile_y, 1, @missile_angle)
    end
    @ship_image.draw_rot(@x, @y, 1, @angle)
  end
end