# frozen_string_literal: false

require_relative './lib/board'
require_relative './lib/game'

game = Game.new(Board.new)
game.play_game
