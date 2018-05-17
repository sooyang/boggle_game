class HomeController < ApplicationController
  include Boggle

  before_action :set_board, only: [:index, :start]
  before_action :set_game, only: [:start]
  before_action :current_game, only: [:select, :add]

  def index
    @board = @new_board.draw
    new_boggle_session
  end

  def start
    @board = @new_board.generate_board
    new_boggle_session
  end

  def select
    response = @current_game.select_char(params["value"], params["index"])
    if response == "ok"
      render json: { selected_char: session[:game]["selected_char"]}, status: 200
    elsif response == "removed"
      render json: { action: "removed", selected_char: session[:game]["selected_char"]}, status: 200
    else
      render json: { action: "error"}, status: 400
    end
  end

  def add
    response = @current_game.add
    if response == "ok"
      render :json => { action: "correct", selected_char: session[:game]["selected_char"]}, status: 200
    elsif response == "short"
      render :json => { action: "short", selected_char: session[:game]["selected_char"]}, status: :bad_request
    else
      render :json => { action: "wrong", selected_char: session[:game]["selected_char"]}, status: :bad_request
    end
    session[:game]["selected_char"] = []
    session[:game]["indexes"] = []
  end

  private

  def set_board
    @new_board = Board.new
  end

  def set_game
    @new_game = Game.new
  end

  def current_game
    @current_game = Game.new(session[:game]["selected_char"], session[:game]["indexes"], session[:game]["words_added"])
  end

  def new_boggle_session
    session[:board] = @board
    session[:game] = @new_game
  end
end
