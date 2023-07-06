# Connect Four Game in Ruby

This repository contains a simple implementation of the classic Connect Four game in Ruby.

## Repository Structure

- `lib/` - Contains the main game logic.
    - `board.rb` - Contains the logic for the game board.
    - `database.rb` - (Placeholder) Will contain the logic for saving and loading game progress.
    - `game.rb` - Contains the main game logic.
- `spec/` - Contains the test files.
    - `board_spec.rb` - Contains tests for the board logic.
    - `database_spec.rb` - (Placeholder) Will contain tests for the database module.
    - `game_spec.rb` - Contains tests for the game logic.
- `main.rb` - The main entry point of the game.
- `.rspec` - RSpec configuration file.

## Getting Started

1. Clone the repository.
2. Navigate to the repository directory.
3. Run `ruby main.rb` to start the game.

## To-Do

- **Add Database Module**: Implement a database module in `lib/database.rb` to save and load game progress. This module should allow players to save the current state of the game and resume it later. Don't forget to add tests for this module in `spec/database_spec.rb`.

- **Handle Draw Condition**: Update the game logic in `lib/game.rb` to handle the scenario where the game ends in a draw (i.e., the board is full and no player has won).

- **Improve Column Selection Logic**: Update the board logic in `lib/board.rb` to handle cases where a player selects a full column. Instead of wasting the player's turn, prompt the player to choose a different column.

- **Improve User Interface**: Work on the user interface to make the game more engaging and user-friendly. Consider adding colors, animations, and user prompts.

## Insights for Future Development

- **AI Opponent**: Implement an AI opponent that players can play against. This can be done using algorithms like Minimax for decision making.

- **Customizable Board Size**: Allow players to customize the size of the board before starting the game.

- **Online Multiplayer**: Implement the ability to play the game over a network, allowing two players on different machines to play against each other.

- **Game Statistics**: Keep track of player statistics such as wins, losses, and draws. Display these statistics at the end of each game.

- **Undo Move**: Implement an undo feature that allows players to take back their last move.

- **Themes and Customization**: Allow players to choose different themes and customize the appearance of the game board and pieces.

- **Accessibility Features**: Implement features that make the game accessible to a wider range of players, such as screen reader support and alternative input methods.

## Contributing

Contributions are welcome! Feel free to submit a pull request or create an issue to discuss any changes or improvements.

## Contribution

https://github.com/pkasprzak9
