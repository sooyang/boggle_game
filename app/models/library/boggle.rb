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
    def initialize(selected_char = [], indexes = [], words_added = [], scores = [])
      @selected_char = selected_char
      @indexes = indexes
      @words_added = words_added
      @scores = scores
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

      evaluate_word
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

    def populate_score(valid_word)
      if valid_word
        @scores << 1
      else

        @scores << -1
      end
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
      if @selected_char.first == '*'
        selected_word = @selected_char.join.downcase.slice(1)
      else
        arr = []
        @selected_char.each_with_index do |char, i|
          if char == "*"
            break
          elsif @selected_char.count - 1 == i
            break
          else
            arr << char
          end
        end
        selected_word = arr.join.downcase
      end

      # Read dictionary with the word formed
      @list_of_words = File.readlines("lib/dictionary.txt").grep(/#{selected_word}/)
    end

    def evaluate_word
      # Only take words with equal length to the selected char by player
      filter_by_word_length = @list_of_words.map {|word| word.gsub("\n", "") if word.gsub("\n", "").length == @selected_char.length }.compact

      possible_words = compare_against_dictionary(filter_by_word_length)

      filtered_words_added_by_length = @words_added.map {|word| word if word.length == @selected_char.length }.compact
      words_used = compare_against_words_used(filtered_words_added_by_length)

      # the number of possible words must be more than 0 and words added for actual word and words with wildcard must be less than the number of possible words
      valid_word = possible_words.count(true) > 0 && words_used.count(true) < possible_words.count(true)

      # additional condition for words without wildcard to ensure they exist in dictionary
      valid_word = filter_by_word_length.include?(@selected_char.join.downcase) if !@selected_char.include?('*')
      populate_words_added(@selected_char)
      populate_score(valid_word)
      valid_word ? "ok" : "wrong"
    end

    def compare_against_dictionary(arr_of_possible_words)
      if @selected_char.include?('*')
        compared_by_char_position = compare_selected_with_possible_words(arr_of_possible_words)
      else
        # get all possible words if selected char does not have wildcard
        compared_by_char_position = arr_of_possible_words.map {|word| word.split("").each_with_index.map{|char, i|  (@selected_char.count - 1) == i  ? true : char == @selected_char[i].downcase }}
      end
      only_matching_characters(compared_by_char_position)
    end

    def compare_against_words_used(arr_of_possible_words)
      # Compare the position of each character with the selected char by player
      if @selected_char.include?('*')
        compared_by_char_position = compare_selected_with_possible_words(arr_of_possible_words)
      else
        # for checking against words already added
        compared_by_char_position = arr_of_possible_words.map {|word| word.split("").each_with_index.map{|char, i|  char == "*" ? true : char == @selected_char[i].downcase }}
      end
      only_matching_characters(compared_by_char_position)
    end

    def compare_selected_with_possible_words(arr_of_possible_words)
      arr_of_possible_words.map {|word| word.split("").each_with_index.map{|char, i|  @selected_char[i] == "*" ? true : char == @selected_char[i].downcase }}
    end

    def only_matching_characters(compared_by_char_position)
      # we know that the word is true once the number of character and position matches
      compared_by_char_position.map {|x| x.count(true) == @selected_char.count}
    end
  end
end
