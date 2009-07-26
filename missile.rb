class Missile
  attr_accessor :x, :y, :angle, :time_fired
  
  def initialize(x,y,angle,window)
    @image = Gosu::Image::new(window, "images/missile.png", false)
    @x = x
    @y = y
    @angle = angle
    @time_fired = Time.now
  end
  
  def update
    @x += Gosu::offset_x(@angle, 4.0)
    @y += Gosu::offset_y(@angle, 4.0)
    @image.draw_rot(@x, @y, 1, @angle)
  end
  
  def offscreen?
    if @x > 800 or @x < 0 or @y > 800 or @y < 0
      return true
    end
    false
  end

end