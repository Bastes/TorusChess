module TorusChess
  module CellularMapPatch
    def [](x, y) # :nodoc:
      super x % 8, y % 8
    end

    def []=(x, y, content) # :nodoc:
      super x % 8, y % 8, content
    end
  end
end
