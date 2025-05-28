# frozen_string_literal: true

# Game class
class Game
  attr_accessor :code_maker, :code_breaker

  COLORS = %w[red yellow green blue cyan magenta].freeze
  def initialize
    puts 'Welcome to Mastermind!'.colorize(:yellow)
    do_role_select
    @black_pegs = 0
    @white_pegs = 0
  end

  def do_role_select # rubocop:disable Metrics/MethodLength
    puts "Will you be the #{'Code-Maker'.colorize(:green)} or the #{'Code-Breaker'.colorize(:red)}?\n
1 - #{'Code-Maker'.colorize(:green)}\n2 - #{'Code-Breaker'.colorize(:red)}\n\n"
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
    puts ''
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
    puts "\nYour selection: #{simplify_code_string(code)}\n\n"
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
    code
  end

  def compare_guess_with_code(guess, code)
    puts "Code before assessment: #{simplify_code_string(@secret_code)}"
    @black_pegs = 0
    @white_pegs = 0
    guess.each_with_index do |guessed_peg, index|
      next unless code.include?(guessed_peg)

      code.each_with_index do |code_peg, idx|
        next unless guessed_peg == code_peg

        guess[index] == code[index] ? @black_pegs += 1 : @white_pegs += 1
        code[idx] = '<found>'
        break
      end
    end
    puts "Code: #{simplify_code_string(code)}\nGuess: #{simplify_code_string(guess)}\n\n"
    puts "Black Pegs: #{@black_pegs}".colorize(:gray)
    puts "White Pegs: #{@white_pegs}\n\n"
  end

  def win_game(code_breaker)
    puts "The code has been broken after #{@turn_number} guesses!"
  end

  def play_game
    puts "\nThe #{@code_maker.name.colorize(:green)} will now prepare a secret code...\n"
    @secret_code = create_code(@code_maker.play_method)
    puts "\nThe Secret Code has been created!\n\n"
    @turn_number = 1
    while @turn_number <= 12
      if @black_pegs == 4
        win_game(@code_breaker)
        break
      end
      puts "----------Guess #{@turn_number}/12----------"
      @current_guess = create_code(@code_breaker.play_method)
      # binding.pry
      compare_guess_with_code(@current_guess, @secret_code)
      @turn_number += 1
    end
  end
end
