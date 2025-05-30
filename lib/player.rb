# frozen_string_literal: true

# Player class
class Player
  attr_reader :name, :role, :play_method

  def initialize(name, role, play_method)
    @role = role
    @role_color = role == 'Code Breaker' ? :red : :green
    @name = name.colorize(@role_color)
    @play_method = play_method
  end

  def to_s
    "#{@name} - #{@role}\nPlay Method: #{@play_method}"
  end
end
