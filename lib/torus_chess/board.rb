require 'cellular_map'
require 'torus_chess/piece'
require 'torus_chess/cellular_map_patch'

module TorusChess
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
            half = l.collect { |p| p ? [c, (p == :royal ? royal : p)] : nil }
            royal == :king ? half.reverse : half
          }.inject { |a, b| a + b } }
        c == :black ? side.reverse : side
      }.inject { |a, b| a + b }
      position.each_index { |y| position[y].each_index { |x|
        self[x, y] = Piece[*position[y][x]] if position[y][x]
      } }
    end
  end
end