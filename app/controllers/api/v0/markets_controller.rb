class Api::V0::MarketsController < ApplicationController
  def index
    markets = Market.all
    require 'pry'; binding.pry
    render json: MarketSerializer.format_markets(markets)
  end
end