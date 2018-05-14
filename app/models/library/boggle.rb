module Boggle
  class Board
    def initialize(board, selected = [], indexes = [], added = [])
      @board = board
      @selected = selected
      @indexes = indexes
      @added = added
    end

    def draw
      @board.gsub(",", "").gsub(" ", "").chars.each_slice(4).map{|r| r}
    end

    def selected(value, index)
      # byebug
      if @selected.last
        if @selected.last == value && @indexes.last == index
          @selected.pop()
          @indexes.pop()
          return 'removed'
        else
          # byebug
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
    end

    def add
      array = File.readlines("lib/dictionary.txt").grep(/#{@selected.join.downcase}/)
      if @selected.include?('*')
        new_array = array.map {|b| b if b.gsub("\n", "").length == @selected.length }.compact
        newer_array = new_array.map {|a| a.gsub("\n", "")}
        newest_array = newer_array.map {|x| x.split("").each_with_index.map {|b,i| b == @selected[i].downcase} }
        latest = newest_array.map {|a| a.count(true) == @selected.count - @selected.count("*")}

        if latest.count(true) > 0 && @added.count(@selected.join.downcase) < latest.count(true)
          @added << @selected.join.downcase
          return "ok"
        else
          @added << @selected.join.downcase
          return "wrong"
        end
      else
        if array.include?("#{@selected.join.downcase}\n")
          return "ok"
        else
          return "wrong"
        end
      end
    end
  end
end
