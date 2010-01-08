require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'torus_chess'

class Test::Unit::TestCase
  def self.should_allow(moves)
    moves.each { |move|
      should("allow this move #{move.inspect}") {
        check_move(move) { |m, b|
          m.call
          assert_nil b[*move.first.keys.first].content
          assert_equal TorusChess::Piece[*move.first.values.first],
            b[*move.last].content
        }
      }
    }
  end

  def self.should_refuse(moves)
    moves.each { |move|
      should("refuse this move #{move.inspect}") {
        check_move(move) { |m, b|
          assert_raise(TorusChess::RulesError) { m.call }
        }
      }
    }
  end

  private

  def check_move(move, &block)
    board = TorusChess::Board.new
    to_place = move.first
    to_place = to_place.merge(move[1]) if move.length == 3
    to_place.each_pair { |position, piece|
      board[*position] = piece }
    yield lambda { board.move(move.first.keys.first, move.last) }, board
  end
end
