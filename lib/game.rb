# frozen_string_literal: false

require_relative './board'

class Game
  attr_reader :board, :players

  PIECES = %w[x o]

  def initialize(board, turn = 0)
    @board = board
    @turn = turn
    @players = { player1: {}, player2: {} }
  end

  def play_game
    introduction
    create_players
    turn_order
    puts 'game over'
  end

  def create_players
    2.times do |player|
      player += 1
      choose_name(player)
      choose_piece(player)
    end
  end

  def choose_name(player)
    player_key = "player#{player}".to_sym
    puts "\n\e[32mChoose a name for player #{player}"
    verified_name = verify_name
    set_name(verified_name, player_key)
  end

  def verify_name
    loop do
      user_name = gets.chomp
      if user_name != ''
        return user_name
      else
        puts 'Name cannot be empty. Please enter a valid name.'
      end
    end
  end

  def set_name(name, player)
    @players[player][:name] = name
  end

  def choose_piece(player)
    piece1 = PIECES[0]
    piece2 = PIECES[1]
    player_key = "player#{player}".to_sym
    puts "\n\e[32mChoose a piece for player #{player}\nAvailable pieces: '#{piece1}' or '#{piece2}'"
    loop do
      user_piece = gets.chomp
      verified_piece = verify_piece(piece1, piece2, user_piece)
      if verified_piece
        assign_piece(verified_piece, player_key)
        break
      end
      puts "INPUT ERROR: players can choose '#{piece1}' or '#{piece2}' and piece can not be same as other players"
    end
  end

  def assign_piece(piece, player)
    players[player][:piece] = piece
  end

  def verify_piece(piece1, piece2, user_piece)
    user_piece if (user_piece == piece1 || user_piece == piece2) && available?(user_piece)
  end

  def available?(piece)
    return false if players[:player1][:piece] == piece || players[:player2][:piece] == piece

    true
  end

  def turn_order
    @game_over = false
    until @game_over
      players.each do |_player, player_info|
        piece = player_info[:piece]
        board.display_board
        selected_column = select_column
        row, column = board.drop_piece(selected_column, piece)
        @game_over = game_over?(row, column, piece)
        break if @game_over
      end
    end
  end

  def game_over?(row, column, piece)
    board.four_in_row?(row, column, piece)
  end

  def select_column
    available_columns = (1..7)
    chosen_column = gets.chomp.to_i
    verified_column = chosen_column if available_columns.include?(chosen_column)
    return verified_column if verified_column

    puts "\e[32INPUT ERROR!\nPlease select a column from 1 to 7"
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
