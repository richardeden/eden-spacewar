require 'rubygems'
require 'gosu'
require 'ship'
require 'asteroid'

ES_VERSION = '0.1.5'

#setup z-ordering
module ZOrder
  Background, Asteroids, Ships, UI = *0..3
end

class GameWindow < Gosu::Window
  
  def initialize
    super(800, 600, false)
    self.caption = "Eden Spacewar " + ES_VERSION
    @background = Gosu::Image::new(self, "images/background.png", false)
    @player_one_ship = Ship.new(self, 40.0, 40.0, 1)
    @player_two_ship = Ship.new(self, 760.0, 580.0, 2)
    @display_text = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @asteroids = []
    @small_asteroids = []
    @game_over = false
    @winner = 0
    @timer = nil
  end
  
  def restart
    @player_one_ship.reset(40.0, 40.0)
    @player_two_ship.reset(760.0, 580.0)
    @asteroids = []
    @small_asteroids = []
    if @timer.nil?
      @timer = Time.now
    elsif ((Time.now - @timer)  > 3)
        @game_over = false
        @timer = nil
    end
  end

  def update
    if button_down? Gosu::Button::KbA
      update_player_one('turn_left')
    end
    if button_down? Gosu::Button::KbD
      update_player_one('turn_right')
    end
    if button_down? Gosu::Button::KbW
      update_player_one('accelerate')
    end
    if button_down? Gosu::Button::KbF
      update_player_one('fire')
    end
    
    if button_down? Gosu::Button::KbLeft
      update_player_two('turn_left')
    end
    if button_down? Gosu::Button::KbRight
      update_player_two('turn_right')
    end
    if button_down? Gosu::Button::KbUp
      update_player_two('accelerate')
    end
    if button_down? Gosu::Button::KbM
      update_player_two('fire')
    end
   
    if @player_one_ship.firing?
      if @player_one_ship.hit_opponent?(@player_two_ship.x, @player_two_ship.y)
        player_wins(1)
      end
      @asteroids.each do |asteroid|
        if asteroid.hit_by_missile?(@player_one_ship)
          @small_asteroids << Asteroid.new(self, {:x => asteroid.x, :y => asteroid.y})
          @small_asteroids << Asteroid.new(self, {:x => asteroid.x, :y => asteroid.y})
          @small_asteroids.flatten
          @asteroids.delete(asteroid)
        end
      end
      @small_asteroids.each do |small_asteroid|
        if small_asteroid.hit_by_missile?(@player_one_ship)
          @small_asteroids.delete(small_asteroid)
        end
      end
    end

    if @player_two_ship.firing?
      if @player_two_ship.hit_opponent?(@player_one_ship.x, @player_one_ship.y)
        player_wins(2)
      end
      @asteroids.each do |asteroid|
        if asteroid.hit_by_missile?(@player_two_ship)
          @small_asteroids << Asteroid.new(self, {:x => asteroid.x, :y => asteroid.y}) 
          @small_asteroids << Asteroid.new(self, {:x => asteroid.x, :y => asteroid.y})
          @small_asteroids.flatten
          @asteroids.delete(asteroid)
        end
      end
      @small_asteroids.each do |small_asteroid|
        if small_asteroid.hit_by_missile?(@player_two_ship)
          @small_asteroids.delete(small_asteroid)
        end
      end
    end
    
    unless @asteroids.empty?
      @asteroids.each do |asteroid|
        if asteroid.collision?(@player_one_ship.x, @player_one_ship.y)
          player_wins(2)
        elsif asteroid.collision?(@player_two_ship.x, @player_two_ship.y)
          player_wins(1)
        end
      end
    end
    
    if rand(1000) < 3 && @asteroids.size < 5
      @asteroids << Asteroid.new(self)
    end
    
    update_asteroids
    @player_one_ship.move_ship
    @player_two_ship.move_ship
  end
  
  def update_player_one(action=nil)
    unless action.nil?
      @player_one_ship.send(action)
    end
  end
  
  def update_player_two(action=nil)
    unless action.nil?
      @player_two_ship.send(action) 
    end
  end
  
  def player_wins(player_num)
    @game_over = true
    @winner = player_num
  end

  def draw
    @background.draw(0,0,0)
    draw_asteroids
    if @game_over
      @display_text.draw("Player #{@winner} wins!!!", 350, 300, 1, 1.0, 1.0, 0xffffff00)
      restart
    else
      @player_one_ship.draw
      @player_two_ship.draw
    end
  end
  
  def button_down(id)
    if id == Gosu::Button::KbEscape
      close
    end
  end
  
  #loop through the asteroids and draw
  def draw_asteroids
    unless @asteroids.empty?
      @asteroids.each do |asteroid|
        asteroid.draw
      end
    end
    @small_asteroids.flatten.each do |small_asteroid|
      small_asteroid.draw
    end
  end
  
  def update_asteroids
    @asteroids.each do |asteroid|
      @asteroids.delete(asteroid) if asteroid.offscreen?
      asteroid.update
    end
    @small_asteroids.each do |small_asteroid|
      @small_asteroids.delete(small_asteroid) if small_asteroid.offscreen?
      small_asteroid.update
    end
  end
  
end

window = GameWindow.new.show