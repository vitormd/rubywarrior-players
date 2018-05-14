module Statuses
  def print_statuses
    puts '-------------------'
    statuses.each { |status| puts status }
    puts '-------------------'
  end

  def statuses
    [
      "HP: #{@last_turn_health} -> #{@warrior.health}",
      "Direction: #{@direction}",
      "Facing side: #{@facing_side}"
    ]
  end
end