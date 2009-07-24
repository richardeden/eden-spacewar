require 'rubygems'
require 'gosu'
require 'ship'

class GameWindow < Gosu::Window
  
  def initialize
    super(800, 600, false)
    self.caption = "Eden - Code Something Cool in 2 Hours"
    @background = Gosu::Image::new(self, "images/background.png", false)
    @player_one_ship = Ship.new(self, 40.0, 40.0, 1)
    @player_two_ship = Ship.new(self, 760.0, 580.0, 2)
    @display_text = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @game_over = false
    @winner = 0
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
    end

    if @player_two_ship.firing?
      if @player_two_ship.hit_opponent?(@player_one_ship.x, @player_one_ship.y)
        player_wins(2)
      end
    end
    
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
    if @game_over
      @display_text.draw("Player #{@winner} wins!!!", 300, 300, 1, 1.0, 1.0, 0xffffff00)
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
end

window = GameWindow.new.show