class HomeController < ApplicationController
  include Boggle

  def index
    @draw_board = Board.new(", , , , , , , , , , , , , , , ")
    @board = @draw_board.draw

    session[:game] =  @draw_board
    byebug
  end

  def start
    o = [('A'..'Z')].map(&:to_a).flatten <<  "*"
    string = (0...16).map { o[rand(o.length)] }.join(", ")

    @draw_board = Board.new(string)
    @board = @draw_board.draw
    session[:game] =  @draw_board
  end

  def select
    board = Board.new("T, A, P, *, E, A, K, S, O, B, R, S, S, *, X, D", session[:game]["selected"], session[:game]["indexes"], session[:game]["added"]).selected(params["value"], params["index"])
    if board == "ok"
      render :json => { :selected => session[:game]["selected"]}, :status => 200
    elsif board == "removed"
      render :json => { :word => "removed", :selected => session[:game]["selected"]}, :status => 200
    else
      render :json => { :word => "error "}, :status => 400
    end
  end

  def add
    board = Board.new("T, A, P, *, E, A, K, S, O, B, R, S, S, *, X, D", session[:game]["selected"], session[:game]["indexes"], session[:game]["added"]).add
    if board == "ok"
      render :json => { :word => "correct", selected: session[:game]["selected"]}, :status => 200
      session[:game]["selected"] = []
      session[:game]["indexes"] = []
    else
      render :json => { :word => "wrong", selected: session[:game]["selected"]}, status: :bad_request
      session[:game]["selected"] = []
      session[:game]["indexes"] = []
    end
  end

  private
end
