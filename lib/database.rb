# frozen_string_literal: false

require 'yaml'

module DataBase
  SAVE_FILE = './log/saves.yaml'.freeze

  def save_to_YAML
    game_date = {
      'players' => @players,
      'turn' => @turn,
      'winner' => @winner,
      'grid' => @board.grid
    }
    File.open(SAVE_FILE, 'w') { |f| f.write(game_date.to_yaml) }
  rescue SystemCallError => e
    puts 'Error while saving the progress.'
    puts e
  end

  def load_from_YAML
    if File.exist?(SAVE_FILE)
      data = YAML.load_file(SAVE_FILE)
      @players = data['players']
      @turn = data['turn']
      @winner = data['winner']
      @board.grid = data['grid']
    else
      puts 'No saved games to load.'
    end
  end

  def clear_save_file
    File.delete(SAVE_FILE) if File.exist?(SAVE_FILE)
  end
end
