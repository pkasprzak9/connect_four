# frozen_string_literal: false

require_relative './board'
require_relative './database'

class Game
  include DataBase
  attr_reader :board, :players, :turn, :winner

  PIECES = %w[x o].freeze

  def initialize(board, turn = 0)
    @board = board
    @turn = turn
    @players = { player1: {}, player2: {} }
    @winner = nil
  end

  def play_game
    introduction
    create_players unless (load_game if File.exist?(SAVE_FILE))
    turn_order
    if play_again?
      clear_game
      play_game
    end
  end

  def clear_game
    @board.set_up
    @players = { player1: {}, player2: {} }
    @turn = 0
    @winner = nil
  end

  def play_again?
    puts "\nWould you like to play again"
    answer = verify_answer(gets.chomp) until answer
    return true if answer == 'yes'

    false
  end

  def load_game
    puts "\nWould you like to laod the previous game (yes/no)?"
    loop do
      answer = verify_answer(gets.chomp)
      if answer == 'yes'
        load_from_YAML
        clear_save_file
        return true
      elsif answer == 'no'
        clear_save_file
        return false
      end
    end
    false
  end

  def verify_answer(answer)
    availabe_answers = %w[yes no]
    puts "\nINPUT ERROR: Please enter a valid answer" unless availabe_answers.include?(answer)
    answer if availabe_answers.include?(answer)
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
    puts "\nChoose a name for player #{player}"
    verified_name = verify_name
    set_name(verified_name, player_key)
  end

  def verify_name
    loop do
      user_name = gets.chomp
      if user_name != ''
        return user_name
      else
        puts "\nName cannot be empty. Please enter a valid name."
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
    puts "\nChoose a piece for player #{player}\nAvailable pieces: '#{piece1}' or '#{piece2}'"
    loop do
      user_piece = gets.chomp
      verified_piece = verify_piece(piece1, piece2, user_piece)
      if verified_piece
        assign_piece(verified_piece, player_key)
        break
      end
      puts "\nINPUT ERROR: players can choose '#{piece1}' or '#{piece2}' and piece can not be same as other players"
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
    game_over = false
    until game_over
      players.each do |_player, player_info|
        board.display_board
        break if game_over

        row, column = process_player_turn(player_info)
        game_over = game_over?(row, column, player_info[:piece])
      end
    end
  end

  def process_player_turn(player_info)
    @turn += 1
    display_turn_info(player_info[:name])

    player_input = select_column_or_quit
    if player_input == :quit
      quit_game
    else
      make_move(player_input, player_info[:piece])
    end
  end

  def make_move(column, piece)
    board.drop_piece(column, piece)
  end

  def game_over?(row, column, piece)
    board.four_in_row?(row, column, piece)
  end

  def select_column_or_quit
    @verified_column = nil
    until @verified_column
      available_columns = (1..7)
      input = gets.chomp
      return :quit if input == 'quit'

      chosen_column = input.to_i
      @verified_column = chosen_column if verify_column(available_columns, chosen_column)
      return @verified_column if @verified_column

      puts "\nINPUT ERROR!\nPlease select a column from 1 to 7" unless available_columns.include?(chosen_column)
      puts "\nINPUT ERROR!\nSelected column is full.\nPlease select different column" if board.column_full?(chosen_column)
    end
  end

  def verify_column(available_columns, column)
    available_columns.include?(column) && !board.column_full?(column)
  end

  def display_turn_info(name)
    puts "\nRound: #{@turn}\n#{name}'s turn"
  end

  def quit_game
    puts "\nWould you like to save the progress (yes/no)"
    answer = gets.chomp
    save_to_YAML if answer == 'yes'
    puts "\nQuiting game..."
    exit
  end

  private

  def introduction
    puts <<~HERODOC

      Welcome to CONNECT FOUR game!

      Game Instructions:

          1. Players take turns dropping their symbols into columns.
          2. Enter the column number and press Enter to drop the symbol or quit to quit the game.
          3. Connect four symbols in a row horizontally, vertically, or diagonally to win.
          4. Have fun and good luck!
    HERODOC
  end
end
