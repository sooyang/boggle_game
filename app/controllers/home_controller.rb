class HomeController < ApplicationController
  include Boggle

  def index
    @draw_board = Board.new("T, A, P, *, E, A, K, S, O, B, R, S, S, *, X, D")
    @board = @draw_board.draw
    session[:game] =  @draw_board
  end

  def select
    board = Board.new("T, A, P, *, E, A, K, S, O, B, R, S, S, *, X, D", session[:game]["selected"], session[:game]["indexes"]).selected(params["value"], params["index"])
    if board == "ok"
      render :json => { :word => "masquerade_word "}, :status => 200
    elsif board == "removed"
      render :json => { :word => "removed"}, :status => 200
    else
      render :json => { :word => "masquerade_word "}, :status => 400
    end
  end
end
