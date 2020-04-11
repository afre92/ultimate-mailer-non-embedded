# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :find_shop_and_verify_token


  # private
  def find_shop
    if params[:shop] && Shop.find_by(shopify_domain: params[:shop]).present?
      @shop = Shop.find_by(shopify_domain: params[:shop])
    else
      return false
    end
  end

  def find_shop_and_verify_token
    if !(find_shop && verify_token)
      redirect_to not_found_path
    end
  end


  def verify_token
    local_token = @shop.web_token+Date.current.month.to_s
    @token = Digest::SHA2.hexdigest local_token
    if params[:token] != @token
      return false
    else
      return true
    end
  end
end
