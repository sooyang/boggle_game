module Boggle
  class Board
    def initialize(board = ", , , , , , , , , , , , , , , ")
      @board = board
    end

    def generate_board
      characters = [('A'..'Z')].map(&:to_a).flatten <<  "*"
      @board = (0...16).map { characters[rand(characters.length)] }.join(", ")
      draw
    end

    def draw
      board_string = @board.gsub(",", "")
      @board =
        if board_string.blank?
          board_string.chars.each_slice(4).map{|r| r}
        else
          board_string.gsub(" ", "").chars.each_slice(4).map{|r| r}
        end
    end
  end

  class Game
    def initialize(selected_char = [], indexes = [], words_added = [])
      @selected_char = selected_char
      @indexes = indexes
      @words_added = words_added
    end

    def select_char(value, index)
      if @selected_char.empty?
        populate_selected_char(value, index)
      else
        check_previous_selection(value, index)
      end
    end

    def add
      # Minimum 3 characters to form a word
      return "short" if @selected_char.count < 3

      check_with_dictionary

      if @selected_char.include?('*')
        evaluate_word_with_wildcard
      else
        evaluate_word_without_wildcard
      end
    end

    private

    def populate_selected_char(value, index)
      @selected_char << value
      @indexes << index
      return "ok"
    end

    def populate_words_added(word)
      @words_added << word.join.downcase
    end

    def check_previous_selection(value, index)
      # if previously selected, clicking again indicates user intent to remove selection
      if @selected_char.last == value && @indexes.last == index
        @selected_char.pop()
        @indexes.pop()
        return 'removed'
      else
        check_adjacent_selection(value, index)
      end
    end

    def check_adjacent_selection(value, index)
      # Rule for checking
      # i) from current tile, index x +- 1
      # ii) from current tile, index y +- 1
      # iii) Cannot be one of previously selected index
      selected_xindex = index.first.to_i
      selected_yindex = index.last.to_i
      current_xindex = @indexes.last.first.to_i
      current_yindex = @indexes.last.last.to_i

      if selected_xindex.between?(current_xindex - 1, current_xindex + 1) &&
        selected_yindex.between?(current_yindex - 1, current_yindex + 1) &&
        !@indexes.include?(index)
        populate_selected_char(value, index)
      else
        return "error"
      end
    end

    def check_with_dictionary
      selected_word = if @selected_char.first == '*'
        @selected_char.join.downcase.slice(1)
      else
        @selected_char.join.downcase
      end

      # Read dictionary with the word formed
      @list_of_words = File.readlines("lib/dictionary.txt").grep(/#{selected_word}/)
    end

    def evaluate_word_without_wildcard
      selected_char = @selected_char.join.downcase

      # Check if selected word is in the dictionary list and have not been added by the player
      valid_word = @list_of_words.include?("#{selected_char}\n") && @words_added.count(selected_char) < 1
      populate_words_added(@selected_char)
      valid_word ? "ok" : "wrong"
    end

    def evaluate_word_with_wildcard
      # Only take words with equal length to the selected char by player
      filter_by_word_length = @list_of_words.map {|word| word.gsub("\n", "") if word.gsub("\n", "").length == @selected_char.length }.compact

      # Compare the position of each character with the selected char by player
      filter_by_char_position = filter_by_word_length.map {|x| x.split("").each_with_index.map {|b,i| b == @selected_char[i].downcase} }

      # Since wildcards can be from A-Z, we know that the word is true once the number of character and position matches minus the amount of wilcard
      possible_words = filter_by_char_position.map {|a| a.count(true) == @selected_char.count - @selected_char.count("*")}

      # the number of possible words must be more than 0 and words added must be less than the number of possible words
      valid_word = possible_words.count(true) > 0 && @words_added.count(@selected_char.join.downcase) < possible_words.count(true)
      populate_words_added(@selected_char)
      valid_word ? "ok" : "wrong"
    end
  end
end
