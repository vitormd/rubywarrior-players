require 'actions.rb'
require 'statuses.rb'

class Player
  include Actions
  include Statuses
  MAX_HEALTH = 20

  def play_turn(warrior)
    init(warrior)
    print_statuses
    choose_action
    post_action
  end

  private

  def init(warrior)
    @warrior          = warrior
    @last_turn_health ||= MAX_HEALTH
    @facing_side      ||= :right
    @direction        ||= wall?(:left) ? :right : :left
  end

  def choose_action
    if @direction != @facing_side
      pivot!(@direction)
    elsif should_rest?
      rest!
    elsif empty?
      if health < @last_turn_health && health < 10
        retreat!
      else
        walk!
      end
    elsif captive?
      rescue!
    elsif wall?
      change_direction
      pivot!
    else
      attack!
    end
  end

  def should_rest?
    health < MAX_HEALTH && health >= @last_turn_health
  end

  def post_action
    @last_turn_health = health
  end
end


