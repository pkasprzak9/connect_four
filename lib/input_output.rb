# frozen_string_literal: true

module InputOutput
  PIECES = ["\e[34m\u25cf\e[0m", "\e[33m\u25cf\e[0m"].freeze
  EMPTY_CELL_COLOR = "\u25cb"
  SEPARATOR = '|'

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

  def ask_for_name_message(player)
    puts "\nChoose a name for player #{player}"
  end

  def empty_name_error
    puts "\nName cannot be empty. Please enter a valid name."
  end

  def choose_piece_message(player, piece1, piece2)
    puts "\nChoose a piece for player #{player}\nAvailable pieces: '1': #{piece1}' or '2': #{piece2}'"
  end

  def choose_piece_error(piece1, piece2)
    puts "\nINPUT ERROR! players can choose '1': #{piece1}' or '2': #{piece2}' and piece can not be same as other players"
  end

  def play_again_message
    puts "\nWould you like to play again(yes/no)?"
  end

  def load_game_message
    puts "\nWould you like to laod the previous game (yes/no)?"
  end

  def invalid_answer_error
    puts "\nINPUT ERROR: Please enter a valid answer"
  end

  def display_winner(player_info)
    puts "\n#{player_info[:name]} WINS!"
  end

  def invalid_column_error
    puts "\nINPUT ERROR!\nPlease select a column from 1 to #{board.COLUMNS}"
  end

  def full_column_error
    puts "\nINPUT ERROR!\nSelected column is full.\nPlease select different column"
  end

  def display_turn_info(name)
    puts "\nRound: #{@turn}\n#{name}'s turn"
  end

  def ask_to_save
    puts "\nWould you like to save the progress (yes/no)"
    answer = verify_answer(gets.chomp) until answer
    answer
  end

  def quit_message
    puts "\nQuiting game..."
  end
end
