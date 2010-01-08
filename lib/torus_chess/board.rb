require 'cellular_map'
require 'torus_chess/piece'
require 'torus_chess/cellular_map_patch'

module TorusChess
  class RulesError < Exception # FIXME : would be quite better in its file.
  end

  # =The toric chess board.
  #
  # Quite like a chess board, only toric (northern and southern sides are
  # connected, as well as eastern and western sides, wich makes backstabbing
  # more fun).
  # 
  # Starting position is :
  #  8 bR .. bB .. .. bB .. bR
  #  7 bP bP .. .. .. .. bP ..
  #  6 bK .. bP bQ b+ bP .. bK
  #  5 .. .. .. bP bP .. .. ..
  #  4 .. .. .. wP wP .. .. ..
  #  3 wK .. wP wQ w+ wP .. wK
  #  2 wP wP .. .. .. .. wP ..
  #  1 wR .. wB .. .. wB .. wR
  #    A  B  C  D  E  F  G  H
  #
  #  ( w, b = white, black
  #    + = King
  #    Q = Queen
  #    R = Rook
  #    K = Knight
  #    B = Bishop
  #    P = Pawn )
  class Board < CellularMap::Zone
    def initialize # :nodoc:
      super 0..7, 0..7, CellularMap::Map.new
      @map.extend CellularMapPatch
    end

    # List of the pieces on the board, positions included.
    def pieces
      @map.to_a
    end

    # Resets the pieces to the initial position.
    def reset!
      @map.empty!
      base = [ [ :rook,   nil,   :bishop, nil    ],
               [ :pawn,   :pawn, nil,     nil    ],
               [ :knight, nil,   :pawn,   :royal ],
               [ nil,     nil,   nil,     :pawn  ] ]
      position = [:white, :black].collect { |c|
        side = base.collect { |l| [:queen, :king].
          collect { |royal|
            half = l.collect { |p| p ? Piece[c, p == :royal ? royal : p] : nil }
            royal == :king ? half.reverse : half
          }.inject { |a, b| a + b } }
        c == :black ? side.reverse : side
      }.inject { |a, b| a + b }
      position.each_index { |y| position[y].each_index { |x|
        self[x, y] = position[y][x]
      } }
    end

    # Attempts to execute a move, according to the rules and current position.
    # piece:: is the starting position ([x, y])
    # move:: is the target destination ([x, y])
    # promotion:: use to promote a pawn explicitely to something else than queen
    #
    # A move breaking the rules will raise a TorusChess::RulesError.
    def move(start, destination, promotion = :queen)
      piece = self[*start].content
      raise RulesError.new unless piece
      vector = destination.zip(start).
        collect { |d, s| d - s }.
        collect { |v| [v % 8, (v % 8 - 8)] }.
        collect { |a, b| a.abs <= b.abs ? a : b }
      case piece.rank
      when :pawn
        black = (piece.colour == :black)
        d = (black ? -1 : 1)
        case v = [vector.first.abs, vector.last * d]
        when [0, 1], [0, 2]
          if v.last == 2
            raise RulesError.new unless start.last == (black ? 6 : 1)
            raise RulesError.new if self[start[0], start[0] + d].content
          end
          raise RulesError.new if self[*destination].content
        when [1, 1]
          other = self[*destination].content
          raise RulesError.new if other.nil? || (other.colour == piece.colour)
        else raise RulesError.new
        end
      else raise RulesError.new
      end
      self[*destination] = self[*start].content
      self[*start] = nil
    end
  end
end
