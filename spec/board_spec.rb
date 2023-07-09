# frozen_string_literal: false

require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }
  describe '#set_up' do
    it 'sets up the board with 7 columns and 6 rows' do
      correct_grid = [[nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil]]
      board.set_up
      expect(board.grid).to eql(correct_grid)
    end
  end
  describe '#drop_piece' do
    context 'when the chosen column is empty' do
      before do
        allow(board).to receive(:row_empty?).and_return(true)
      end
      context 'when user chooses first column' do
        it 'place the piece correctly' do
          value = 'x'
          board.drop_piece(1, value)
          expect(board.grid[5][0]).to eql(value)
        end
      end
      context 'when user chooses last column' do
        it 'place the piece correctly' do
          value = 'x'
          board.drop_piece(6, value)
          expect(board.grid[5][5]).to eql(value)
        end
      end
    end
    context 'when the chosen column is not empty' do
      context 'when the column already has one element' do
        before do
          allow(board).to receive(:row_empty?).and_return(false, true)
        end
        context 'when chosen column does not exist' do
          it 'returns nil' do
            value = 'x'
            board.drop_piece(10, value)
            expect(board.grid[5][9]).to be_nil
          end
        end
        context 'when user chooses first column' do
          it 'place the piece correctly' do
            value = 'x'
            board.drop_piece(1, value)
            expect(board.grid[4][0]).to eql(value)
          end
        end
        context 'when user chooses last column' do
          it 'place the piece correctly' do
            value = 'x'
            board.drop_piece(6, value)
            expect(board.grid[4][5]).to eql(value)
          end
        end
      end
    end
    context 'when the column is full' do
      before do
        allow(board).to receive(:row_empty?).and_return(false, false, false, false, false, false)
      end
      it 'returns nil' do
        value = 'x'
        expect(board.drop_piece(1, value)).to be_nil
      end
    end
  end

  describe '#display_board' do
    let(:output) { StringIO.new }
    before do
      $stdout = output
    end

    after do
      $stdout = STDOUT
    end

    context 'when the board is empty' do
      it 'displays an empty board correctly' do
        board.display_board
        empty_cell = "\u25cb "
        empty_row = "#{empty_cell * 7}\n"
        expected_output = empty_row * 6
        expect(output.string).to eq(expected_output)
      end
    end
  end

  describe '#four_in_row?' do
    context 'when there are four pieces in a row' do
      context 'when the pieces are alligned horizontally' do
        subject(:board_horizontal) { described_class.new }
        it 'returns true' do
          piece = 'x'
          board.drop_piece(1, piece)
          board.drop_piece(2, piece)
          board.drop_piece(3, piece)
          row, column = board.drop_piece(4, piece)
          expect(board.four_in_row?(row, column, piece)).to be true
        end
      end
      context 'when the pieces are alligned vertically' do
        subject(:board_horizontal) { described_class.new }
        it 'returns true' do
          piece = 'x'
          board.drop_piece(1, piece)
          board.drop_piece(1, piece)
          board.drop_piece(1, piece)
          row, column = board.drop_piece(1, piece)
          expect(board.four_in_row?(row, column, piece)).to be true
        end
      end
    end
  end
end
