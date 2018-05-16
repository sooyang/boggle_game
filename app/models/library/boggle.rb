module Boggle
  class Board
    def initialize(board, selected = [], indexes = [], added = [])
      @board = board
      @selected = selected
      @indexes = indexes
      @added = added
    end

    def draw
      @board =
        if @board.gsub(",", "").blank?
          @board.gsub(",", "").chars.each_slice(4).map{|r| r}
        else
          @board.gsub(",", "").gsub(" ", "").chars.each_slice(4).map{|r| r}
        end
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
      word = if @selected.first == '*'
        @selected.join.downcase.slice(1)
      else
        @selected.join.downcase
      end
      array = File.readlines("lib/dictionary.txt").grep(/#{word}/)
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
        if array.include?("#{@selected.join.downcase}\n") && @added.count(@selected.join.downcase) < 1
          @added << @selected.join.downcase
          return "ok"
        else
          @added << @selected.join.downcase
          return "wrong"
        end
      end
    end
  end
end
