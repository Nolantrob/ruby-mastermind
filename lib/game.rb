# frozen_string_literal: true

# Game class
class Game
  attr_accessor :code_maker, :code_breaker

  COLORS = %w[red green blue magenta].freeze
  def initialize
    system 'clear'
    puts 'Welcome to MASTERMIND!'.colorize(:yellow)
    do_role_select
    @black_pegs = 0
    @white_pegs = 0
    @guesses = []
  end

  def do_role_select # rubocop:disable Metrics/MethodLength
    roles = [{ name: 'Code-Maker'.colorize(:green),
               description: "You will create a secret sequence of 4 colors out of #{COLORS.size} options" },
             { name: 'Code-Breaker'.colorize(:red),
               description: "You are given 12 guesses to try and figure out the Code-Maker's secret code." }]
    puts "Will you be the #{roles[0][:name]} or the #{roles[1][:name]}?"
    puts "1 - #{roles[0][:name]}: #{roles[0][:description]}\n2 - #{roles[1][:name]}: #{roles[1][:description]}\n\n"
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

  def underline(string)
    "\e[4m#{string}\e[0m"
  end

  def print_options
    puts "\n#{underline('Options')}:\n"
    COLORS.each_with_index do |color, index|
      puts "#{index + 1} - #{color.capitalize.colorize(color.to_sym)}"
    end
  end

  def select_color(method)
    case method
    when 'automatic'
      COLORS.sample
    when 'manual_select'
      loop do
        answer = gets.to_i
        return COLORS[answer - 1] unless answer <= 0 || answer > COLORS.size || !answer.is_a?(Integer)

        print 'Invalid Choice: Please try again: '
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
      puts "#{COLORS.find_index(chosen_color) + 1} - #{chosen_color.capitalize.colorize(chosen_color.to_sym)}"
    end
    code
  end

  def simplify_code_string(code)
    code.map { |color| color.capitalize.colorize(color.to_sym) }.join(', ')
  end

  def create_code(method)
    case method
    when 'automatic'
      code = generate_random_code
    when 'manual_select'
      code = prompt_user_to_make_code
    end
    @guesses.push(code)
    code
  end

  def hide_found_element_from_code(guess, code)
    manipulated_code = code.map { |el| el }
    guess.each_with_index do |guessed_peg, index|
      next unless manipulated_code.include?(guessed_peg)

      manipulated_code.each_with_index do |code_peg, idx|
        next unless guessed_peg == code_peg

        guess[index] == manipulated_code[index] ? @black_pegs += 1 : @white_pegs += 1
        manipulated_code[idx] = '<found>'
        break
      end
    end
  end

  def compare_guess_with_code(guess, code)
    @black_pegs = 0
    @white_pegs = 0
    hide_found_element_from_code(guess, code)
  end

  def win_game(turn_number)
    puts "Success! The #{@code_breaker.name} has cracked the code after #{turn_number - 1} guesses!"
  end

  def lose_game
    puts "#{@code_breaker.name} has failed to crack the code!\nBetter luck next time!"
  end

  def run_intro_text
    puts "\nThe #{@code_maker.name} will now prepare a secret code...\n"
    @secret_code = create_code(@code_maker.play_method)
    puts "\nThe Secret Code has been created!\n\n"
  end

  def display_guesses_in_order
    puts ''
    @guesses.each_with_index do |guess, index|
      puts "Guess ##{index + 1}: #{simplify_code_string(guess)} - #{peg_count}"
    end
    puts ''
  end

  def peg_count
    "#{@black_pegs.to_s.colorize(:gray)}/#{@white_pegs}"
  end

  def code_breaker_make_guess(turn_number)
    puts "----------Round #{turn_number}/12----------"
    @current_guess = create_code(@code_breaker.play_method)
    # binding.pry
    compare_guess_with_code(@current_guess, @secret_code)
    display_guesses_in_order
  end

  def play_game
    run_intro_text
    turn_number = 1
    while turn_number <= 12
      if @black_pegs == 4
        win_game(turn_number)
        break
      end
      code_breaker_make_guess(turn_number)
      turn_number += 1
    end
    lose_game if @black_pegs < 4
  end
end
