# frozen_string_literal: true

require 'pry-byebug'
require 'colorize'

require_relative 'lib/game'
require_relative 'lib/player'

def begin_game
  mastermind = Game.new
  mastermind.play_game
end

loop do
  yes_statements = %w[y yes sure ok okay yeah ye yea]
  no_statements = %w[n no nope nah]

  begin_game
  loop do
    print "\nPlay again? (Y/N): "
    answer = gets.to_s.chomp
    if yes_statements.include?(answer)
      begin_game
      next
    end
    if no_statements.include?(answer)
      system 'clear'
      exit
    end

    puts 'Invalid Choice: Please try again.'
  end
end
