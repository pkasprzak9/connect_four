# frozen_string_literal: false

require_relative '../lib/game'
require_relative '../lib/board'

describe Game do
  let(:board) { instance_double(Board) }
  subject(:game) { described_class.new(board) }

end
