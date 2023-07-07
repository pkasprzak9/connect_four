# frozen_string_literal: false

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/database'

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
          message = "\nName cannot be empty. Please enter a valid name."
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
          message = "\nName cannot be empty. Please enter a valid name."
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
      subject(:game_turn_order) { described_class.new(board) }
      let(:board) { double('Board') }

      before do
        allow(game_turn_order).to receive(:process_player_turn)
        allow(board).to receive(:display_board)
      end

      it 'processes each player\'s turn' do
        allow(game_turn_order).to receive(:game_over?).and_return(false, false, true)
        expect(game_turn_order).to receive(:process_player_turn).exactly(3).times # Adds first iteration
        game_turn_order.turn_order
      end

      it 'stops looping when the game_over? is true' do
        allow(game_turn_order).to receive(:game_over?).and_return(true)
        expect(game_turn_order).to receive(:process_player_turn).once
        game_turn_order.turn_order
      end
    end

    describe '#select_column_or_quit' do
      let(:board) { instance_double(Board) }
      subject(:game_select_column) { described_class.new(board) }
      before do
        allow(game_select_column).to receive(:puts)
        allow(board).to receive(:column_full?)
      end

      context 'when user selects a valid column' do
        before do
          allow(game_select_column).to receive(:gets).and_return('3')
        end

        it 'returns the selected column' do
          selected_column = game_select_column.select_column_or_quit
          expect(selected_column).to eq(3)
        end
      end
      context 'when user enters quit' do
        before do
          allow(game_select_column).to receive(:gets).and_return("quit\n")
        end

        it 'returns :quit' do
          selected_column = game_select_column.select_column_or_quit
          expect(selected_column).to eq(:quit)
        end
      end
    end

    describe '#process_player_turn' do
      let(:board) { instance_double(Board) }
      let(:player_info) { { name: 'Paweł', piece: 'x' } }
      subject(:game_player_turn) { described_class.new(board) }

      before do
        allow(game_player_turn).to receive(:display_turn_info)
      end

      context 'when player chooses a valid column' do
        before do
          allow(game_player_turn).to receive(:select_column_or_quit).and_return(3)
        end
        it 'calls #make_move with the selected column and player\'s piece' do
          expect(game_player_turn).to receive(:make_move).with(3, 'x')
          game_player_turn.process_player_turn(player_info)
        end
      end

      context 'when user enters quit' do
        before do
          allow(game_player_turn).to receive(:select_column_or_quit).and_return(:quit)
        end

        it 'calls quit_game' do
          expect(game_player_turn).to receive(:quit_game)
          game_player_turn.process_player_turn(player_info)
        end
      end
    end

    describe '#make_move' do
      let(:board) { instance_double(Board) }
      subject(:game_move) { described_class.new(board) }

      it 'calls #drop_piece method' do
        piece = 'x'
        column = 1
        expect(board).to receive(:drop_piece).with(column, piece)
        game_move.make_move(column, piece)
      end
    end

    describe '#quit_game' do
      let(:board) { instance_double(Board) }
      subject(:game_quit) { described_class.new(board) }

      before do
        allow(game_quit).to receive(:puts)
        allow(game_quit).to receive(:save_to_YAML)
      end

      context 'when user wants to save progress' do
        it 'calls save_to_YAML' do
          allow(game_quit).to receive(:gets).and_return('yes')
          expect(game_quit).to receive(:save_to_YAML)
          game_quit.quit_game
        end
      end

      context 'when user does not want to save progress' do
        it 'does not call save_to_YAML' do
          allow(game_quit).to receive(:gets).and_return('no')
          expect(game_quit).not_to receive(:save_to_YAML)
          game_quit.quit_game
        end
      end

      it 'prints a message asking if the user wants to save the progress' do
        allow(game_quit).to receive(:gets).and_return('no')
        expect(game_quit).to receive(:puts).with("\e[32mWould you like to save the progress (yes/no)\e[0m")
        game_quit.quit_game
      end

      it 'prints a quit message' do
        quit_message = "\e[32mQuiting game...]"
        allow(game_quit).to receive(:gets).and_return('no')
        expect(game_quit).to receive(:puts).with(quit_message)
        game_quit.quit_game
      end
    end

    describe '#save_to_YAML' do
      let(:board) { instance_double(Board) }
      let(:file_path) { './log/saves.yaml' }
      let(:content) { 'some content' }
      subject(:game_save) { described_class.new(board) }

      before do
        allow(game_save).to receive(:dump_to_YAML).and_return(content)
      end

      it 'saves content to a file' do
        expect(File).to receive(:open).with(file_path, 'w')
        game_save.save_to_YAML
      end

      context 'when there\'s an error message' do
        before do
          allow(File).to receive(:open).and_raise(SystemCallError.new('error message'))
        end

        it 'outputs the error message' do
          expect { game_save.save_to_YAML }.to output(/Error while saving the progress./).to_stdout
        end
      end
    end
  end
end
