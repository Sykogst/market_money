class Api::V0::MarketVendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :validation_error_response

  def index
    market = Market.find(params[:market_id])
    vendors = market.vendors
    render json: VendorSerializer.new(vendors)
  end

  def create
    v = Vendor.find(params[:market_vendor][:vendor_id])
    m = Market.find(params[:market_vendor][:market_id])
    # require 'pry'; binding.pry
    market_vendor = MarketVendor.create!(market_vendor_params)
    head 201
    # render json: market_vendor, status: :created
    # render json: MarketVendorSerializer.new(market_vendor), status: 201
  end

  private

  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id)
  end
 
  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end

  def validation_error_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 400))
      .serialize_json, status: :bad_request
  end
end