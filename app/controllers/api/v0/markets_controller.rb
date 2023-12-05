class Api::V0::MarketsController < ApplicationController
  def index
    markets = Market.all
    render json: MarketSerializer.new(markets)
  end

  def show
    market = Market.find(params[:id])
    render json: MarketSerializer.new(market)
  end
end