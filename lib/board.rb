# frozen_string_literal: true

class Board
  attr_reader :grid

  ROWS = 6
  COLUMNS = 7
  EMPTY_CELL_COLOR = "\e[32m"
  SEPARATOR = '|'

  def initialize
    set_up
  end

  def set_up
    @grid = Array.new(ROWS) { Array.new(COLUMNS) }
  end

  def drop_piece(column, value)
    column -= 1
    row = grid.size - 1
    return if column.negative? || column >= grid.first.size

    while row >= 0
      if row_empty?(row, column)
        @grid[row][column] = value
        break
      end
      row -= 1
    end
  end

  def display_board
    ROWS.times do |row|
      COLUMNS.times do |column|
        if grid[row][column].nil?
          print "#{EMPTY_CELL_COLOR}#{SEPARATOR} "
        else
          print "#{SEPARATOR}#{grid[row][column]}"
        end
      end
      puts SEPARATOR
    end
  end

  private

  def row_empty?(row, column)
    grid[row][column].nil?
  end
end

# board = Board.new
# board.drop_piece(1, 'x')
# board.drop_piece(2, 'x')
# board.drop_piece(2, 'x')
# board.drop_piece(6, 'x')
# board.display_board
