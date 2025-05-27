# frozen_string_literal: true

# Game class
class Game
  attr_accessor :code_maker, :code_breaker

  COLORS = %w[red orange yellow green blue purple brown black].freeze
  def initialize
    puts 'Welcome to Mastermind!'
    do_role_select
  end

  def do_role_select # rubocop:disable Metrics/MethodLength
    puts "Will you be the Code-Maker or the Code-Breaker?\n
1 - Code-Maker\n2 - Code-Breaker\n\n"
    print 'Your choice: '
    loop do
      answer = gets.to_i
      case answer
      when 1
        @code_maker = Player.new('Human', 'Code Maker', 'manual_select')
        @code_breaker = Player.new('Computer', 'Code Breaker', 'automatic')
        return
      when 2
        @code_maker = Player.new('Computer', 'Code Maker', 'automatic')
        @code_breaker = Player.new('Human', 'Code Breaker', 'manual_select')
        return
      else
        puts 'Invalid Choice: Please try again.'
      end
    end
  end

  def print_options
    COLORS.each_with_index do |color, index|
      puts "#{index + 1} - #{color.capitalize}"
    end
  end

  def select_color(method)
    case method
    when 'automatic'
      COLORS.sample
    when 'manual_select'
      loop do
        answer = gets.to_i
        return COLORS[answer - 1] unless answer <= 0 || answer > 6 || !answer.is_a?(Integer)

        puts 'Invalid Choice: Please try again.'
      end
    end
  end

  def generate_random_code
    Array.new(4) { select_color('automatic') }
  end

  def prompt_user_to_make_code
    code = []
    print_options
    position = 0
    position_verbiage = %w[first second third final]
    while position < 4
      print "\nWhat will be your #{position_verbiage[position]} color?: "
      position += 1
      chosen_color = select_color('manual_select')
      code.push(chosen_color)
      puts "#{COLORS.find_index(chosen_color) + 1} - #{chosen_color.capitalize}"
    end
    puts "\nYour code: #{simplify_code_string(code)}"
    code
  end

  def simplify_code_string(code)
    code.map(&:capitalize).join(', ')
  end

  def create_code(method)
    case method
    when 'automatic'
      code = generate_random_code
    when 'manual_select'
      code = prompt_user_to_make_code
    end
    code
  end

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

  def play_game
    puts "\n#{@code_maker.name}, prepare your secret code...\n\n"
    @secret_code = create_code(@code_maker.play_method)
    puts 'Secret Code has been created.'
  end
end
