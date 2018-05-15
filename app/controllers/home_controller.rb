class HomeController < ApplicationController
  include Boggle

  def index
    @draw_board = Board.new("T, A, P, *, E, A, K, S, O, B, R, S, S, *, X, D")
    # @draw_board = Board.new("A, C, E, D, L, U, G, *, E, *, H, T, G, A, F, K")
    @board = @draw_board.draw
    session[:game] =  @draw_board
  end

  def select
    board = Board.new("T, A, P, *, E, A, K, S, O, B, R, S, S, *, X, D", session[:game]["selected"], session[:game]["indexes"], session[:game]["added"]).selected(params["value"], params["index"])
    if board == "ok"
      render :json => { :word => "masquerade_word ", :selected => session[:game]["selected"]}, :status => 200
    elsif board == "removed"
      render :json => { :word => "removed", :selected => session[:game]["selected"]}, :status => 200
    else
      render :json => { :word => "masquerade_word "}, :status => 400
    end
  end

  def add
    board = Board.new("T, A, P, *, E, A, K, S, O, B, R, S, S, *, X, D", session[:game]["selected"], session[:game]["indexes"], session[:game]["added"]).add
    if board == "ok"
      render :json => { :word => "correct"}, :status => 200
    else
      render :json => { :word => "wrong"}, :status => 400
    end
  end
end
