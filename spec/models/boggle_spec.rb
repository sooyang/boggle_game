require 'rails_helper'

RSpec.describe Boggle::Board do
  let(:board) { Boggle::Board.new }

  describe ".draw" do
    context "blank board" do
      it 'returns a 4x4 array with empty string elements' do
        expect(board.draw).to eq([[" ", " ", " ", " "], [" ", " ", " ", " "], [" ", " ", " ", " "], [" ", " ", " "]])
      end
    end
    context "board with letters" do
      it 'returns a 4x4 array with the respective characters elements' do
        board = Boggle::Board.new("T, A, P, *, E, A, K, S, O, B, R, S, S, *, X, D")
        expect(board.draw).to eq([["T", "A", "P", "*"], ["E", "A", "K", "S"], ["O", "B", "R", "S"], ["S", "*", "X", "D"]])
      end
    end
  end

  describe ".generate_board" do
    it 'returns a 4x4 array with random character elements' do
      expect(board.generate_board).to eq(board.instance_values["board"])
    end
  end
end

RSpec.describe Boggle::Game do
  let(:game) { Boggle::Game.new }

  describe ".select_char" do
    context "first character" do
      before do |example|
        unless example.metadata[:skip_before]
          game.select_char("A", "0,0")
        end
      end

      it 'returns ok', skip_before: true do
        expect(game.select_char("A", "0,0")).to eq("ok")
      end

      it 'adds the character to the selected character array' do
        expect(game.instance_values["selected_char"][0]).to eq("A")
      end

      it 'adds the character index to the indexes array' do
        expect(game.instance_values["indexes"][0]).to eq("0,0")
      end
    end

    context "multiple characters" do
      before do
        game.select_char("A", "0,0")
      end

      context "previously selected" do
        it 'returns removed' do
          expect(game.select_char("A", "0,0")).to eq("removed")
        end

        it 'removes the character to the selected character array' do
          expect do
            game.select_char("A", "0,0")
          end.to change { game.instance_values["selected_char"] }.from(["A"]).to([])
        end

        it 'removes the character index to the indexes array' do
          expect do
            game.select_char("A", "0,0")
          end.to change { game.instance_values["indexes"] }.from(["0,0"]).to([])
        end
      end

      context "new charcter selected" do
        context "is adjacent to the last character selected" do
          before do |example|
            unless example.metadata[:skip_before]
              game.select_char("B", "1,1")
            end
          end

          context "have not been selected" do
            it 'returns ok', skip_before: true do
              expect(game.select_char("B", "1,1")).to eq("ok")
            end

            it 'adds the character to the selected character array' do
              expect(game.instance_values["selected_char"].last).to eq("B")
            end

            it 'adds the character index to the indexes array' do
              expect(game.instance_values["indexes"].last).to eq("1,1")
            end
          end

          context "have been selected" do
            before do |example|
              unless example.metadata[:skip_before]
                game.select_char("A", "0,0")
              end
            end

            it 'returns error' do
              expect(game.select_char("A", "0,0")).to eq("error")
            end

            it 'does not adds the character to the selected character array' do
              expect(game.instance_values["selected_char"].last).to_not eq("A")
            end

            it 'does not adds the character index to the indexes array' do
              expect(game.instance_values["indexes"].last).to_not eq("0,0")
            end
          end
        end

        context "is not adjacent to the last character selected" do
          before do |example|
            unless example.metadata[:skip_before]
              game.select_char("C", "2,2")
            end
          end

          it 'returns error', skip_before: true do
            expect(game.select_char("C", "2,2")).to eq("error")
          end

          it 'does not adds the character to the selected character array' do
            expect(game.instance_values["selected_char"].last).to_not eq("C")
          end

          it 'does not adds the character index to the indexes array' do
            expect(game.instance_values["indexes"].last).to_not eq("2,2")
          end
        end
      end
    end
  end

  describe ".add" do
    let(:short) { Boggle::Game.new(["A", "B"], ["0,0", "0,1"]) }
    let(:correct_word_without_wildcard) { Boggle::Game.new(["C", "O", "D", "E"], ["0,0", "0,1", "0,2", "0,3"]) }
    let(:wrong_word_without_wildcard) { Boggle::Game.new(["A", "S", "D"], ["0,0", "0,1", "0,2"]) }
    let(:correct_word_with_wildcard) { Boggle::Game.new(["C", "O", "D", "*"], ["0,0", "0,1", "0,2", "0,3"]) }
    let(:wrong_word_with_wildcard) { Boggle::Game.new(["D", "D", "*"], ["0,0", "0,1", "0,2"]) }

    context "short text" do
      before do |example|
        unless example.metadata[:skip_before]
          short.add
        end
      end

      it "returns short", skip_before: true do
        expect(short.add).to eq("short")
      end

      it "does not add the word to words added array" do
        expect(short.instance_values["words_added"]).to_not eq(["AB"])
      end

      it "does not add to score" do
        expect(short.instance_values["scores"]).to_not eq([1])
      end
    end

    context "with wildcard" do
      context "word exists in dictionary" do
        it 'returns ok' do
          expect(correct_word_with_wildcard.add).to eq('ok')
        end

        it "adds the word to words added array" do
          expect do
            correct_word_with_wildcard.add
          end.to change { correct_word_with_wildcard.instance_values["words_added"] }.from([]).to(["cod*"])
        end

        it "adds to score" do
          expect do
            correct_word_with_wildcard.add
          end.to change { correct_word_with_wildcard.instance_values["scores"] }.from([]).to([1])
        end
      end

      context "word does not exists in dictionary" do
        it 'returns wrong' do
          expect(wrong_word_with_wildcard.add).to eq('wrong')
        end

        it "adds the word to words added array" do
          expect do
            wrong_word_with_wildcard.add
          end.to change { wrong_word_with_wildcard.instance_values["words_added"] }.from([]).to(["dd*"])
        end

        it "adds to score" do
          expect do
            wrong_word_with_wildcard.add
          end.to change { wrong_word_with_wildcard.instance_values["scores"] }.from([]).to([-1])
        end
      end
    end

    context "without wildcard" do
      context "word exists in dictionary" do
        it 'returns ok' do
          expect(correct_word_without_wildcard.add).to eq('ok')
        end

        it "adds the word to words added array" do
          expect do
            correct_word_without_wildcard.add
          end.to change { correct_word_without_wildcard.instance_values["words_added"] }.from([]).to(["code"])
        end

        it "adds to score" do
          expect do
            correct_word_without_wildcard.add
          end.to change { correct_word_without_wildcard.instance_values["scores"] }.from([]).to([1])
        end
      end

      context "word does not exists in dictionary" do
        it 'returns wrong' do
          expect(wrong_word_without_wildcard.add).to eq('wrong')
        end

        it "adds the word to words added array" do
          expect do
            wrong_word_without_wildcard.add
          end.to change { wrong_word_without_wildcard.instance_values["words_added"] }.from([]).to(["asd"])
        end

        it "adds to score" do
          expect do
            wrong_word_without_wildcard.add
          end.to change { wrong_word_without_wildcard.instance_values["scores"] }.from([]).to([-1])
        end
      end
    end
  end
end
