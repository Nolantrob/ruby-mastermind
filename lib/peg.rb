# frozen_string_literal: true

# Initialize peg class
class Peg
  def initialize(color, position)
    @color = color
    @position = position
  end

  def in_sequence?
  end

  def in_correct_position?
  end

  def to_s
    "#{@color.capitalize} peg in position #{@position}"
  end
end
