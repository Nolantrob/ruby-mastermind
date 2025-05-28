# frozen_string_literal: true

require 'pry-byebug'
require 'colorize'

require_relative 'lib/game'
require_relative 'lib/player'

mastermind = Game.new

mastermind.play_game
