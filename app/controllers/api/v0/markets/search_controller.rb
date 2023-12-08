class Api::V0::Markets::SearchController < ApplicationController
  def markets
    if params[:city] && !params[:state]
      params_combination_validator_error
    else
      markets = Market.search(params[:state], params[:city], params[:name])
      render json: SearchSerializer.format_market_search(markets), status: 200
    end
  end

  private

  def params_combination_validator_error
    render json: ErrorSerializer.new(ErrorMessage.new("Invalid params combination, needs state included, or just name", 422))
      .serialize_json, status: 422
  end
end