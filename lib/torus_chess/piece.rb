module TorusChess
  # What you put on a chess board, toric boards included.
  class Piece
    # Colour and type of a piece.
    attr_reader :colour, :type

    # Acceptable colours and types
    COLOURS = [:black, :white]
    TYPES = [:pawn, :bishop, :knight, :rook, :queen, :king]

    # Access to pieces goes through this method.
    def self.[](*args)
      piece = self.new(*args)
      @pieces ||= []
      @pieces.detect { |p| p == piece } || ((@pieces << piece) && piece)
    end

    def ==(other) # :nodoc:
      [@colour, @type] == [other.colour, other.type]
    end

    protected

    def initialize(*args) # :nodoc:
      params = args.flatten
      if params.length == 1
        params = params.to_s.split(/ |_/)
      end
      if params.length == 2
        params = params.collect { |a| a.to_sym }
        params.reverse! unless COLOURS.include? params.first
        raise ArgumentError unless COLOURS.include? params.first
        raise ArgumentError unless TYPES.include? params.last
        @colour, @type = params
      else
        raise ArgumentError
      end
    rescue ArgumentError
      raise ArgumentError.new "A #{args.flatten.inspect} is not a chess piece."
    end
  end
end
