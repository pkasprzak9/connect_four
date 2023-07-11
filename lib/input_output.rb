# frozen_string_literal: true

require 'colorize'
require 'colorized_string'

module InputOutput
  PIECES = ["\e[1m\e[31m\u25cf\e[0m", "\e[1m\e[36m\u25cf\e[0m"].freeze
  EMPTY_CELL_COLOR = "\e[1m\e[35m\u25cb\e[0m"

  def introduction
    puts <<~HERODOC

      \e[32m\e[1mWelcome to \e[35mCONNECT FOUR\e[32m game!

          Game Instructions:

          1. Players take turns dropping their symbols into columns.
          2. Enter the column number and press Enter to drop the symbol or quit to quit the game.
          3. Connect four symbols in a row horizontally, vertically, or diagonally to win.
          4. Have fun and good luck!
    HERODOC
  end

  def ask_for_name_message(player)
    puts "\nChoose a name for \e[1m\e[35mplayer #{player}\e[32m"
  end

  def empty_name_error
    puts "\n\e[31mName cannot be empty. Please enter a valid name.\e[32m"
  end

  def choose_piece_message(player, piece1, piece2)
    puts "\nChoose a piece for \e[35mplayer #{player}\e[32m\nAvailable pieces: '1': #{piece1}\e[32m\e[1m' or '2': #{piece2}\e[32m\e[1m"
  end

  def choose_piece_error(piece1, piece2)
    puts "\n\e[31m\e[1mINPUT ERROR! players can choose '1': #{piece1}\e[1m\e[31m' or '2': #{piece2}\e[1m\e[31m' and piece can not be same as other players\e[32m"
  end

  def display_turn_info(name)
    puts "\e[1m\e[32m\nRound: #{@turn}\n\e[35m#{name}\e[1m's\e[32m turn"
  end

  def play_again_message
    puts "\e[35m\nWould you like to play again(yes/no)?\e[32m"
  end

  def load_game_message
    puts "\e[35m\nWould you like to laod the previous game (yes/no)?\e[32m"
  end

  def invalid_answer_error
    puts "\e[31m\nINPUT ERROR: Please enter a valid answer\e[32m"
  end

  def display_winner(player_info)
    puts "\e[1m\e[35m\n#{player_info[:name]}\e[1m\e[32m WINS!"
  end

  def invalid_column_error
    puts "\e[31m\nINPUT ERROR!\nPlease select a column from 1 to 7\e[32m"
  end

  def full_column_error
    puts "\e[35m\nINPUT ERROR!\nSelected column is full.\nPlease select different column\e[32m"
  end


  def ask_to_save
    puts "\e[35m\nWould you like to save the progress (yes/no)\e[32m"
    answer = verify_answer(gets.chomp) until answer
    answer
  end

  def quit_message
    puts "\n\e[31mQuiting game...\e[32m"
  end
end
