module Actions
  def health
    @warrior.health
  end

  def feel(direction = @facing_side)
    @warrior.feel(direction)
  end

  def empty?(direction = @facing_side)
    feel(direction).empty?
  end

  def wall?(direction = @facing_side)
    feel(direction).wall?
  end

  def look(direction = @facing_side)
    @warrior.look(direction).first.to_s
  end

  def captive?(direction = @facing_side)
    feel(direction).captive?
  end

  def walk!(direction = @facing_side)
    @warrior.walk!(direction)
  end

  def rescue!(direction = @facing_side)
    @warrior.rescue!(direction)
  end

  def attack!(direction = @facing_side)
    @warrior.attack!(direction)
  end

  def shoot!(direction = @facing_side)
    @warrior.shoot!(direction)
  end

  def rest!
    @warrior.rest!
  end

  def change_direction
    @direction = (@direction == :forward ? :backward : :forward)
  end

  def pivot!(direction = @direction)
    @facing_side = direction
    @warrior.pivot!(direction)
  end
end