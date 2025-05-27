# frozen_string_literal: true

# Player class
class Player
  attr_reader :name, :role, :play_method

  def initialize(name, role, play_method)
    @name = name
    @role = role
    @play_method = play_method
  end

  def to_s
    "#{@name} - #{@role}\nPlay Method: #{@play_method}"
  end
end
