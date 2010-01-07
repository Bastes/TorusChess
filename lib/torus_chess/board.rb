require 'cellular_map'
require 'torus_chess/piece'
require 'torus_chess/cellular_map_patch'

module TorusChess
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
  end
end
