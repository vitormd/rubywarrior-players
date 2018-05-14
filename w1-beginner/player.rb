require 'actions.rb'
require 'statuses.rb'
require 'pry'

class Player
  include Actions
  include Statuses
  MAX_HEALTH = 20

  def play_turn(warrior)
    init(warrior)
    print_statuses
    choose_action
    take_action
    post_action
  end

  private

  def init(warrior)
    @warrior          = warrior
    @last_turn_health ||= MAX_HEALTH
    @facing_side      ||= :forward
    @direction        ||= :forward
    @walls_found      ||= 0
    @found_stairs     ||= false
    @stairs_side      = nil
    @wall_side        = nil
    @action_to_take   = nil
    @action_direction = nil
  end

  def take_action
    if @action_direction
      send(@action_to_take, @action_direction)
    else
      send(@action_to_take)
    end
  end

  def choose_action
    rest_decision
    return if @action_to_take

    analyse_view(:forward)
    return if @action_to_take
    analyse_view(:backward)
    return if @action_to_take

  end

  def rest_decision
    if health < MAX_HEALTH && health >= @last_turn_health
      @action_to_take = 'rest!'
      @action_direction = nil
    end
  end

  def analyse_view(direction)
    view = @warrior.look(direction)

    view.each_with_index do |space, distance|
      exploring_decision(space, direction, distance)
      break if @action_to_take
      captive_decision(space, direction)
      break if @action_to_take
      enemy_decision(space, direction)
      break if @action_to_take
      movement_decision(space, direction)
    end
  end

  def exploring_decision(space, direction, distance)
    if space.to_s == 'nothing' && distance == 2
      @action_to_take = 'walk!'
      @action_direction = direction
    end
  end

  def movement_decision(space, direction)
    if space.stairs?
      @action_to_take = 'walk!'
      @action_direction = direction
    elsif space.wall?
      @action_to_take ||= 'pivot!'
      @action_direction ||= change_direction
    end
  end

  def captive_decision(space, direction)
    if space.captive?
      if captive?(direction)
        @action_to_take ||= 'rescue!'
        @action_direction ||= direction
      else
        @action_to_take ||= 'walk!'
        @action_direction ||= direction 
      end
    end
  end

  def enemy_decision(space, direction)
    if space.enemy?
      @action_direction = direction
      if %w[w S a].include?(space.character)
        if feel(direction).enemy?
          @action_to_take = 'attack!'
        else
          @action_to_take = 'shoot!'
        end
      end
    end
  end

  def post_action
    @last_turn_health = health
  end
end


