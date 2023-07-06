# frozen_string_literal: false

require_relative '../lib/game'
require_relative '../lib/board'

describe Game do
  context 'CREATING PLAYERS' do
    let(:board) { instance_double(Board) }
    describe '#choose_name' do
      subject(:game_choose) { described_class.new(board) }
      before do
        allow(game_choose).to receive(:puts)
        allow(game_choose).to receive(:gets).and_return('Agnieszka')
      end
      it 'calls #set_name with correct name' do
        expect(game_choose).to receive(:set_name).with('Agnieszka', :player1)
        game_choose.choose_name(1)
      end
    end

    describe '#verify_name' do
      subject(:game_verify) { described_class.new(board) }
      context 'when the name is not empty' do
        before do
          allow(game_verify).to receive(:puts)
          allow(game_verify).to receive(:gets).and_return('Agnieszka')
        end
        it 'return name' do
          message = 'Name cannot be empty. Please enter a valid name.'
          expect(game_verify).not_to receive(:puts).with(message)
          game_verify.verify_name
        end
      end
      context 'when user enters empty name once' do
        before do
          allow(game_verify).to receive(:puts)
          allow(game_verify).to receive(:gets).and_return('', 'Agnieszka')
        end
        it 'display error message once' do
          message = 'Name cannot be empty. Please enter a valid name.'
          expect(game_verify).to receive(:puts).with(message).once
          game_verify.verify_name
        end
      end
    end

    describe '#set_name' do
      subject(:game_set) { described_class.new(board) }
      it 'correctly assignes choosen name to player' do
        player_key = :player1
        name = 'Agnieszka'
        game_set.set_name(name, player_key)
        expect(game_set.players[player_key][:name]).to eq(name)
      end
    end

    describe '#choose_piece' do
      subject(:game_verify_piece) { described_class.new(board) }
      before do
        allow(game_verify_piece).to receive(:puts)
        allow(game_verify_piece).to receive(:gets).and_return('x')
      end
      it 'calls #assign_piece with correct piece' do
        expect(game_verify_piece).to receive(:assign_piece).with('x', :player1)
        game_verify_piece.choose_piece(1)
      end
    end

    describe '#assign_piece' do
      subject(:game_assign_piece) { described_class.new(board) }
      it 'correctly assigns piece to player' do
        player_key = :player1
        piece = 'x'
        game_assign_piece.assign_piece(piece, player_key)
        expect(game_assign_piece.players[:player1][:piece]).to eq(piece)
      end
    end

    describe '#available?' do
      subject(:game_piece_available) { described_class.new(board) }
      context 'when piece is available' do
        it 'returns true' do
          piece = 'x'
          expect(game_piece_available.available?(piece)).to eq(true)
        end
      end
      context 'when piece is not available' do
        before do
          player_key = :player1
          piece = 'x'
          game_piece_available.assign_piece(piece, player_key)
        end
        it 'returns false' do
          piece = 'x'
          expect(game_piece_available.available?(piece)).to eq(false)
        end
      end
    end
  end
  context 'GAME RULES' do
    describe '#game_over?' do
      let(:board) { instance_double(Board) }
      subject(:game_over) { described_class.new(board) }
      context 'when there are four consecutive pieces' do
        before do
          allow(board).to receive(:four_in_row?).and_return true
        end
        it 'returns true' do
          expect(game_over.game_over?(1, 1, 'x')).to eq(true)
        end
      end
      context 'when there are four consecutive pieces' do
        before do
          allow(board).to receive(:four_in_row?).and_return false
        end
        it 'returns false' do
          expect(game_over.game_over?(1, 1, 'x')).to eq(false)
        end
      end
    end
    describe '#turn_order' do
      let(:board) { instance_double('Board') }
      subject(:game_turn_order) { described_class.new(board) }
      before do
        allow(game_turn_order).to receive(:players).and_return(
          { player1: { name: 'Jan', piece: 'x' },
            player2: { name: 'Paweł', piece: 'o' } }
        )
        allow(game_turn_order).to receive(:puts)
        allow(board).to receive(:display_board)
        allow(game_turn_order).to receive(:select_column).and_return(3)
        allow(board).to receive(:drop_piece).and_return(3, 'x')
        allow(game_turn_order).to receive(:display_turn_info)
        allow(game_turn_order).to receive(:game_over?).and_return(false, false, true)
      end
      it 'loops through players and makes moves until the game is over' do
        expect(board).to receive(:display_board).exactly(4).times
        expect(game_turn_order).to receive(:select_column).exactly(3).times
        expect(board).to receive(:drop_piece).exactly(3).times
        expect(game_turn_order).to receive(:game_over?).exactly(3).times
        expect(game_turn_order).to receive(:display_turn_info).exactly(3).times

        game_turn_order.turn_order
      end
    end
    describe '#select_column' do
      let(:board) { instance_double(Board) }
      subject(:game_select_column) { described_class.new(board) }
      before do
        allow(game_select_column).to receive(:puts)
      end

      context 'when user selects a valid column' do
        before do
          allow(game_select_column).to receive(:gets).and_return('3')
        end

        it 'returns the selected column' do
          selected_column = game_select_column.select_column
          expect(selected_column).to eq(3)
        end
      end
      context 'when user selects a invalid column' do
        before do
          allow(game_select_column).to receive(:gets).and_return('10')
        end

        it 'returns nil' do
          selected_column = game_select_column.select_column
          expect(selected_column).to be_nil
        end
      end
    end
  end
end
