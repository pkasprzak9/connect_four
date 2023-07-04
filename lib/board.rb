# frozen_string_literal: false

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(6) { Array.new(7) }
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

  private

  def row_empty?(row, column)
    grid[row][column].nil?
  end
end
