# frozen_string_literal: true

require_relative 'lib/peg'

puts 'Welcome to Mastermind! Can you guess the secret code?'

def generate_code
  colors = %w[red orange yellow green blue purple]
  code = []
  position = 1

  4.times do
    code.push(Peg.new(colors.sample, position))
    position += 1
  end
  code
end

def choose_color
  colors = %w[red orange yellow green blue purple]
  print "\nYour choice: "
  answer = gets.to_i
  if answer <= 0 || answer > 6 || !answer.is_a?(Integer)
    puts 'Invalid Choice: Please try again.'
    choose_color
  end
  colors[answer - 1]
end

def print_options
  colors = %w[red orange yellow green blue purple]
  colors.each_with_index do |color, index|
    puts "#{index + 1} - #{color.capitalize}"
  end
end

def make_guess
  guess = []
  position = 1

  4.times do
    puts "\nWhat color do you think is in position #{position}?\n\n"
    print_options
    choice = choose_color
    guess.push(Peg.new(choice, position))
    position += 1
  end
  guess
end

puts make_guess
puts generate_code
