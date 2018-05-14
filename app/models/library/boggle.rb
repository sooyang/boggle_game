module Boggle
  class Board
    def initialize(board, selected = [], indexes = [])
      @board = board
      @selected = selected
      @indexes = indexes
    end

    def draw
      @board.gsub(",", "").gsub(" ", "").chars.each_slice(4).map{|r| r}
    end

    def selected(value, index)
      # byebug
      if @selected.last
        if @selected.last == value
          @selected.pop()
          @indexes.pop()
          return 'removed'
        else
          if index.first.to_i.between?(@indexes.last.first.to_i - 1, @indexes.last.first.to_i + 1) && index.last.to_i.between?(@indexes.last.last.to_i - 1, @indexes.last.last.to_i + 1) && !@indexes.include?(index)
            @selected << value
            @indexes << index
            return "ok"
          else
            return "error"
          end
        end
      else
        @selected << value
        @indexes << index
        return "ok"
      end
      session[:game] = self
    end
  end
end
