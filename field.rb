class Field
  attr_reader :map
  attr_accessor :moves, :complete

  def initialize
    @level = @score = @moves = 0
    @amount_of_levels = Maps::Set.length

    @player = Gosu::Image.new("media/player.png")
    @bg_image = Gosu::Image.new("media/bg.jpg", :tileable => true)
    @wall = Gosu::Image.new("media/wall.jpg")
    @dest = Gosu::Image.new("media/destination.png")
    @box = Gosu::Image.new("media/box.png")

    @info = Gosu::Font.new(20)

    @destinations = []
    @init_pos = Hash.new

    @completed = false
    @level_loaded = false
  end

  def check_accomplishment
    load_level(true) if @completed == true
  end

  def complete_level?
    if @destinations == boxes_positions
      @completed = true
      congratulation
    end
  end

  def congratulation
    @score += 10
    @level_complete_z = 3 # show gongratulation text
    @destinations.clear # to stop executing method 'complete_level?'
  end

  def load_level(go_next = false)
    @level += 1 if go_next
   
    @level_complete_z = -1
    @map = Marshal.load( Marshal.dump(Maps::Set[@level]) ) # deep copy
    @moves = 0
    @completed = false
    @destinations.clear
    set_destinations
    set_player_init_pos
    @level_loaded = true
  end

  def set_destinations
    @map.each do |cell|
      @destinations << [cell[:x], cell[:y]] if cell[:type] == :dest
    end
    @destinations.sort!
  end

  def set_player_init_pos
    @map.each do |cell|
      if cell[:type] == :player
        @init_pos[:x] = Marshal.load( Marshal.dump(cell[:x]) ) 
        @init_pos[:y] = Marshal.load( Marshal.dump(cell[:y]) )
      end
    end
  end

  def get_player_init_pos
    @init_pos
  end

  def boxes_positions
    boxes = []
    @map.each do |cell|
      boxes << [cell[:x], cell[:y]] if cell[:type] == :box
    end
    boxes.sort!
  end

  def level_loaded?
    @level_loaded
  end

  def reset_level_loaded
    @level_loaded = false
  end

  def catch_key_press(id)
    case id
    when Gosu::KbEscape
      abort
    when Gosu::KbSpace
      unless @completed == true
        load_level
      end
    when Gosu::KbReturn
      if @level + 1 == @amount_of_levels # game is finished
        abort
      else
        check_accomplishment
      end
    else
      return
    end
  end

  def draw
    @bg_image.draw(0, 0, 0)
    @info.draw("Level: #{@level} | Score: #{@score} | Moves: #{@moves}", 10, 480, 1, 1.0, 1.0, 0xff_000000)
    @info.draw("Esc- exit | Space - reset", 280, 480, 1, 1.0, 1.0, 0xff_808080)

    if @level_complete_z > 0
      if @level + 1 < @amount_of_levels 
        Gosu::Image.from_text("Level #{@level} is completed\npress ENTER to continue", 40).draw(50, 100, @level_complete_z)
      else
        Gosu::Image.from_text("You Win", 50).draw(50, 100, @level_complete_z)
      end
    end

    @map.each do |cell|
      case cell[:type]
      when :wall
        @wall.draw(cell[:x], cell[:y], 0)
      when :dest
        @dest.draw(cell[:x], cell[:y], 1)
      when :box
        @box.draw(cell[:x], cell[:y], 0)
      when :player
        @player.draw(cell[:x], cell[:y], 2)  
      end
    end
  end

  def get_cells(coord)
    cells = []
    @map.each do |cell|
      cells << cell if cell[:x] == coord[:x] && cell[:y] == coord[:y]
    end
    cells
  end

  def get_cell_type(coord)
    cells = get_cells(coord)
    case cells.length
    when 0
      return :free
    when 1
      return cells[0][:type]
    when 2
      return :box_on_dest
    end
  end

  def set_cell_pos(coord, type, new_x, new_y)
    cells = get_cells(coord)
    if cells.length > 0
      cells.each do |cell|
        if cell[:type] == type
          # Next lines change @map hash's values 
          cell[:x] = new_x
          cell[:y] = new_y
          break
        end
      end
    end
  end

end