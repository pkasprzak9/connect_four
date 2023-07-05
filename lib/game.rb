# frozen_string_literal: false

require_relative './board'

class Game
  attr_reader :board, :players

  def initialize(board, turn = 0)
    @board = board
    @turn = turn
    @players = { player1: {}, player2: {} }
  end

  def play_game
    introduction
    choose_names
  end

  def choose_names
    2.times do |t|
      puts "\n\e[32mChoose a name for player #{t + 1}"
      user_name = gets.chomp
      player_key = "player#{t + 1}".to_sym
      @players[player_key][:name] = user_name
    end
  end

  private

  def introduction
    puts <<~HERODOC
      \e[32m\e[1m
      Welcome to CONNECT FOUR game!\e[0m

      \e[32m\e[1mGame Instructions:\e[0m

          \e[35m1. Players take turns dropping their symbols into columns.
          2. Enter the column number and press Enter to drop the symbol.
          3. Connect four symbols in a row horizontally, vertically, or diagonally to win.
          4. Have fun and good luck!\e[0m
    HERODOC
  end
end

# board = Board.new
# game = Game.new(board)
# game.play_game
# p game.players
