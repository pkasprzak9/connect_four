# frozen_string_literal: false

require 'yaml'

module DataBase
  def save_to_YAML
    File.open('./log/saves.yaml', 'w') { |f| f.write dump_to_YAML }
  rescue SystemCallError => e
    puts 'Error while saving the progress.'
    puts e
  end

  def load_from_YAML

  end

  private

  def dump_to_YAML
    YAML.dump(
      'players' => @players,
      'turns' => @turn,
      'winner' => @winner,
      'board' => @board
    )
  end
end
