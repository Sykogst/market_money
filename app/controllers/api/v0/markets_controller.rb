class Api::V0::MarketsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  
  def index
    markets = Market.all
    render json: MarketSerializer.new(markets)
  end

  def show
    market = Market.find(params[:id])
    render json: MarketSerializer.new(market)
  end

  def nearest_atms
    market = Market.find(params[:market_id])

    conn = Faraday.new(url: "https://api.tomtom.com/search/2/categorySearch/ATM.json") do |faraday|
      faraday.params["lat"] = market.lat
      faraday.params["lon"] = market.lon
      faraday.params["categorySet"] = 7397
      faraday.params["Key"] = Rails.application.credentials.tomtom[:key]
    end
    response = conn.get

    atms = JSON.parse(response.body, symbolize_names: true)

    render json: AtmSerializer.format_atms(atms[:results])
  end

  private
 
  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end
end