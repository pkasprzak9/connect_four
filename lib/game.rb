# frozen_string_literal: false

require_relative './board'
require_relative './database'
require_relative './input_output'

class Game
  include DataBase
  include InputOutput
  attr_reader :board, :players, :turn
  attr_accessor :winner

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
    quit_game
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
    ask_for_name_message(player)
    verified_name = verify_name
    set_name(verified_name, player_key)
  end

  def verify_name
    loop do
      user_name = gets.chomp
      return user_name if user_name != ''

      empty_name_error
    end
  end

  def set_name(name, player)
    @players[player][:name] = name
  end

  def choose_piece(player)
    piece1 = PIECES[0]
    piece2 = PIECES[1]
    player_key = "player#{player}".to_sym
    choose_piece_message(player, piece1, piece2)
    loop do
      user_piece = gets.chomp
      verified_piece = verify_piece('1', '2', user_piece)
      verified_piece = PIECES[0] if verified_piece == '1'
      verified_piece = PIECES[1] if verified_piece == '2'
      if verified_piece
        assign_piece(verified_piece, player_key)
        break
      end
      choose_piece_error(piece1, piece2)
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

  def clear_game
    @board.set_up
    @players = { player1: {}, player2: {} }
    @turn = 0
    @winner = nil
  end

  def play_again?
    play_again_message
    answer = verify_answer(gets.chomp) until answer
    return true if answer == 'yes'

    false
  end

  def load_game
    load_game_message
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
    invalid_answer_error unless availabe_answers.include?(answer)
    answer if availabe_answers.include?(answer)
  end

  def turn_order
    game_over = false
    until game_over
      players.each do |player, player_info|
        row, column = process_player_turn(player_info)
        game_over = game_over?(row, column, player_info[:piece])
        board.display_board
        if game_over
          @winner = player
          display_winner(player_info)
          break
        end
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

      invalid_column_error unless available_columns.include?(chosen_column)
      full_column_error if board.column_full?(chosen_column)
    end
  end

  def verify_column(available_columns, column)
    available_columns.include?(column) && !board.column_full?(column)
  end

  def quit_game
    save_to_YAML if (ask_to_save == 'yes' if @winner.nil?)
    quit_message
    exit
  end
end
