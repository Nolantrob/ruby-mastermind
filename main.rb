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

secret_code = generate_code
guess =       make_guess
p secret_code
p guess
black_pegs = 0
white_pegs = 0

guess.each_with_index do |peg, index|
  next unless secret_code.include?(peg)

  if peg == secret_code[index]
    puts '+1 Black Peg'
  else
    puts '+1 White Peg'
  end
  secret_code[index] = nil
end
