class Player
    def initialize(field)
      @step = 50
      @field = field
      @box = Box.new(@field)
    end

    def initiate_motion(id)
      case id
      when Gosu::KbUp
        @shift = {x: 0, y: -@step}
      when Gosu::KbDown
        @shift = {x: 0, y: @step}
      when Gosu::KbRight
       @shift = {x: @step, y: 0}
      when Gosu::KbLeft
        @shift = {x: -@step, y: 0}
      when Gosu::KbSpace
        set_pos
        return # prevent 'move' execution
      else
        return
      end

      move
    end

    def set_pos
      @init_pos = Marshal.load( Marshal.dump(@field.get_player_init_pos) )
      @x = @init_pos[:x]
      @y = @init_pos[:y]
    end

    def has_obstical?(shift)
      @next_cell = {x: @x + shift[:x], y: @y + shift[:y]}
      @next_cell_type = @field.get_cell_type(@next_cell)

      case @next_cell_type
      when :wall
        return true
      when :box, :box_on_dest
        @box.move(@next_cell, shift)
      else
        return false
      end
    end

    def move
      unless has_obstical?(@shift)
        make_step(@shift)
        @field.moves += 1 #increase movement info
      end
    end

    def make_step(shift)
      @new_x = @x + shift[:x]
      @new_y = @y + shift[:y]
      @field.set_cell_pos({x: @x, y: @y}, :player, @new_x, @new_y )
      @x += shift[:x]
      @y += shift[:y]
    end

end