# карти наступних рівнів
# перехід на наступний рівень
# перемога у грі
# опція почати з початку
# гіфка


require 'gosu'
require './data/maps.rb'
require_relative 'player.rb'
require_relative 'field.rb'
require_relative 'box.rb'

class GameWindow < Gosu::Window
  def initialize
    super 500, 500
    self.caption = "Sokoban ^ by illia108"

    @field = Field.new
    @field.load_level
    @player = Player.new(@field)
    
  end

  def update
    @field.complete_level?
    if @field.level_loaded?
      @player.set_pos
      @field.reset_level_loaded
    end
  end

  def draw
    @field.draw
  end

  def button_down(id) # native gosu function. Run just before update()
    @player.initiate_motion(id)
    @field.catch_key_press(id)
  end

end

window = GameWindow.new
window.show