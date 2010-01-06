module TorusChess
  # What you put on a chess board, toric boards included.
  class Piece
    # Colour and type of a piece.
    attr_reader :colour, :type

    # Access to pieces goes through this method.
    def self.[](colour, type)
      @pieces ||= []
      @pieces.detect { |p| p.colour == colour && p.type = type } ||
        self.new(colour, type)
    end

    protected

    def initialize(colour, type) # :nodoc:
      @colour = colour
      @type = type
    end
  end
end
