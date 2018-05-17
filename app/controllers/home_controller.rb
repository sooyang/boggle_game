class HomeController < ApplicationController
  include Boggle

  def index
    @board = Board.new.draw
    session[:board] = @board
    session[:game] = Game.new
  end
end
