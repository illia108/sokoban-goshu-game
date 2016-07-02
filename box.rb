class Box
  def initialize(field)
    @field = field
  end

  def move(coord, shift)
    @coord = coord
    unless has_obstical?(shift)
      make_step(shift)
      return false
    end
    return true
  end

  def has_obstical?(shift)
    @x = @coord[:x]
    @y = @coord[:y]
    @next_cell = {x: @x + shift[:x], y: @y + shift[:y]}
    @next_cell_type = @field.get_cell_type(@next_cell)

    case @next_cell_type
    when :wall
      return true
    when :box, :box_on_dest
      return true
    else
      return false
    end
  end

  def make_step(shift)
    @field.set_cell_pos(@coord, :box, @x += shift[:x], @y += shift[:y])
  end

end