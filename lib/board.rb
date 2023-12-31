# frozen_string_literal: true

require_relative './input_output'

class Board
  include InputOutput
  attr_accessor :grid

  ROWS = 6
  COLUMNS = 7

  def initialize
    set_up
  end

  def set_up
    @grid = Array.new(ROWS) { Array.new(COLUMNS) }
  end

  def drop_piece(column, value)
    column -= 1
    row = grid.size - 1

    while row >= 0
      if row_empty?(row, column)
        @grid[row][column] = value
        return [row, column]
      end
      row -= 1
    end
  end

  def four_in_row?(row, column, value)
    directions = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

    directions.any? do |d_row, d_column|
      1.upto(3).all? do |i|
        new_row = row + d_row * i
        new_column = column + d_column * i

        next false if new_row.negative? || new_row >= ROWS || new_column.negative? || new_column >= COLUMNS

        @grid[new_row][new_column] == value
      end
    end
  end

  def display_board
    40.times { puts "\n" }
    ROWS.times do |row|
      COLUMNS.times do |column|
        if grid[row][column].nil?
          print "#{EMPTY_CELL_COLOR} "
        else
          print "#{grid[row][column]} "
        end
      end
      puts "\n"
    end
    1.upto(COLUMNS) do |i|
      print "\e[1m\e[32m#{i} "
    end
    puts "\n"
  end

  def column_full?(column)
    column -= 1
    !grid[0][column].nil?
  end

  private

  def row_empty?(row, column)
    grid[row][column].nil?
  end
end
