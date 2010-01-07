require 'helper'

class TestBoard < Test::Unit::TestCase
  context("A board") {
    setup { @board = TorusChess::Board.new }

    should("be a cellular map zone") {
      assert @board.is_a? CellularMap::Zone
    }

    should("be an 8x8 grid") {
      assert_equal 8,  @board.width
      assert_equal 8,  @board.height
      assert_equal 64, @board.length
    }

    should("start empty") {
      assert_equal [], @board.pieces
      @board.each { |cell| assert_nil cell.content }
    }

    should("know the starting position") {
     @board.reset!
     pieces = {
        [0, 1] => [:white, :pawn],
        [1, 1] => [:white, :pawn],
        [2, 2] => [:white, :pawn],
        [3, 3] => [:white, :pawn],
        [4, 3] => [:white, :pawn],
        [5, 2] => [:white, :pawn],
        [6, 1] => [:white, :pawn],
        [7, 1] => [:white, :pawn],
        [2, 0] => [:white, :bishop],
        [5, 0] => [:white, :bishop],
        [0, 2] => [:white, :knight],
        [7, 2] => [:white, :knight],
        [0, 0] => [:white, :rook],
        [7, 0] => [:white, :rook],
        [3, 2] => [:white, :queen],
        [4, 2] => [:white, :king],
        [0, 6] => [:black, :pawn],
        [1, 6] => [:black, :pawn],
        [2, 5] => [:black, :pawn],
        [3, 4] => [:black, :pawn],
        [4, 4] => [:black, :pawn],
        [5, 5] => [:black, :pawn],
        [6, 6] => [:black, :pawn],
        [7, 6] => [:black, :pawn],
        [2, 7] => [:black, :bishop],
        [5, 7] => [:black, :bishop],
        [0, 5] => [:black, :knight],
        [7, 5] => [:black, :knight],
        [0, 7] => [:black, :rook],
        [7, 7] => [:black, :rook],
        [3, 5] => [:black, :queen],
        [4, 5] => [:black, :king]
      }
      @board.each { |cell|
        if expected = pieces[[cell.x, cell.y]]
          piece = cell.content
          flunk "Should be a #{expected.first} #{expected.last}" if piece.nil?
          assert_equal expected.first, piece.colour
          assert_equal expected.last, piece.type
        else
          assert_nil cell.content
        end
      }
    }

    should("act as a torus") {
      assert_equal @board[7, 5], @board[-9, 13]
      assert_equal @board[5, 1], @board[7, 3] + [6, -10]
    }

    should("let only chess pieces on it") {
      assert_raise(ArgumentError) { @board[4, 0] = :whatever }
      assert_raise(ArgumentError) { @board[1, 3] = ["something", "else"] }
      assert_raise(ArgumentError) { @board[6, 7].content = "something" }
      assert_raise(ArgumentError) { @board[6, 7].content = "something" }
      @board[6, 7] = TorusChess::Piece[:white, :rook]
      @board[3, 2] = [:black, :queen]
      @board[0, 1] = [:bishop, 'white']
      @board[4, 3] = nil
      @board[5, 5].content = 'black knight'
      @board[4, 1].content = :white_pawn
      @board[7, 2].content = nil
    }
  }
end
