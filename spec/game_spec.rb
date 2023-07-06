# frozen_string_literal: false

require_relative '../lib/game'
require_relative '../lib/board'

describe Game do
  context 'Creating players' do
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
  context 'Game rules' do
    describe 'game_over?' do
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
  end
end
