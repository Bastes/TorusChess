module TorusChess
  class Piece
    attr_reader :colour, :type

    def self.[](colour, type)
      @pieces ||= []
      @pieces.detect { |p| p.colour == colour && p.type = type } ||
        self.new(colour, type)
    end

    protected

    def initialize(colour, type)
      @colour = colour
      @type = type
    end
  end
end
