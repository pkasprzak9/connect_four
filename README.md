# Connect Four

Connect Four is a classic board game where two players take turns dropping their pieces into a grid, attempting to connect four of their pieces in a row, column, or diagonal. This repository contains a Ruby implementation of the game that can be played in the terminal.

## Table of Contents

- [Getting Started](#getting-started)
- [How to Play](#how-to-play)
- [Features](#features)
- [Running the Tests](#running-the-tests)
- [Bugs and Issues](#bugs-and-issues)
- [Future Enhancements](#future-enhancements)
- [Contributing](#contributing)

## Getting Started

To play Connect Four, you need to have Ruby installed on your machine. Follow these steps to get the game running:

1. Clone this repository to your local machine.
   ```
   git clone https://github.com/pkasprzak9/connect_four.git
   ```
2. Navigate to the repository directory.
   ```
   cd connect_four
   ```

## How to Play

Connect Four is played on a vertical board, which has seven columns and six rows. The objective of the game is to be the first to form a horizontal, vertical, or diagonal line of four of one's own discs.

1. Players take turns dropping their symbols into columns.
2. Enter the column number (1 to 7) and press Enter to drop the symbol.
3. Type 'quit' if you wish to quit the game. You will have the option to save the game before quitting.
4. Connect four symbols in a row horizontally, vertically, or diagonally to win.
5. Have fun and good luck!

## Features

- **Customizable Player Names**: Players can choose their own names.
- **Piece Selection**: Players can choose their pieces (either 'x' or 'o').
- **Dynamic Board Display**: The board is displayed after each move, showing the current state of the game.
- **Save Game Progress**: Players can save the game progress before quitting.
- **Error Handling**: The game handles invalid inputs and prompts the user to enter valid data.

## Running the Tests

This repository includes a suite of tests to ensure the game is working as expected. To run the tests, navigate to the repository directory and run the following command:

```
rspec
```

## Bugs and Issues

As of the latest update, no bugs have been identified. If you encounter any issues while playing the game, please open an issue in this repository.

## Future Enhancements

- Implement a feature to play against the computer (AI).
- Add more customization options for players (e.g., custom symbols, board size).
- Implement a scoring system to keep track of wins and losses.
- Enhance the user interface for a better gaming experience.

## Contributing

Contributions are welcome! If you have an idea for improving the game or want to fix a bug, feel free to fork the repository and submit a pull request.
