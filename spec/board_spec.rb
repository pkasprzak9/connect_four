# frozen_string_literal: false

require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }
  describe '#initialize' do
    it 'initializes the board with 7 columns and 6 rows' do
      correct_grid = [[nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil]]
      expect(board.grid).to eql(correct_grid)
    end
  end
  describe '#drop_piece' do
    context 'when the chosen column is empty' do
      before do
        allow(board).to receive(:row_empty?).and_return(true)
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
end
