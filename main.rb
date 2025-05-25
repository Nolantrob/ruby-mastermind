# frozen_string_literal: true

def print_options
  colors = %w[red orange yellow green blue purple]
  colors.each_with_index do |color, index|
    puts "#{index + 1} - #{color.capitalize}"
  end
end

def choose_color
  colors = %w[red orange yellow green blue purple]
  loop do
    print "\nYour choice: "
    answer = gets.to_i
    return colors[answer - 1] unless answer <= 0 || answer > 6 || !answer.is_a?(Integer)

    puts 'Invalid Choice: Please try again.'
  end
end

def make_guess
  guess = []
  position = 1

  4.times do
    print "What color do you think is in position #{position}?\n\n"
    print_options
    choice = choose_color
    guess.push(choice)
    position += 1
  end
  guess
end

def generate_code
  colors = %w[red orange yellow green blue purple]
  code = []
  position = 1

  4.times do
    code.push(colors.sample)
    position += 1
  end
  code
end

require 'pry-byebug'

# guess = %w[orange orange orange orange]
# code = %w[orange yellow yellow yellow]
code = generate_code
guess = make_guess

def compare_guess_with_code(guess, code)
  puts "Code: #{code}\n\n"

  guess.each_with_index do |guessed_peg, index|
    # binding.pry
    next unless code.include?(guessed_peg)

    code.each_with_index do |code_peg, idx|
      # binding.pry
      next unless guessed_peg == code_peg

      puts guess[index] == code[index] ? '+1 Black Peg' : '+1 White Peg'
      code[idx] = nil
    end
  end
  "Code: #{code}\nGuess: #{guess}\n\n"
end

puts compare_guess_with_code(guess, code)
