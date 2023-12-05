class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  
  def show
    vendor = Vendor.find(params[:id])
    render json: VendorSerializer.new(vendor)
  end

  def create
    render json: Vendor.create(vendor_params), status: 201
  end

  private
 
  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end