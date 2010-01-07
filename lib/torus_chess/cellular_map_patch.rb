module TorusChess
  module CellularMapPatch
    def [](x, y) # :nodoc:
      super x % 8, y % 8
    end

    def []=(x, y, content) # :nodoc:
      content = TorusChess::Piece[*content] unless content.nil? ||
        content.is_a?(TorusChess::Piece)
      super x % 8, y % 8, content
    end
  end
end
