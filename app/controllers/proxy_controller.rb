require 'openssl'
require 'rack/utils'

class ProxyController < ActionController::Base
  before_action :verify_signature, only: :router

  def reviews
    @reviews = @shop.reviews.where(review_status: 'completed', shopify_product_id: params[:id]).order("submitted_on DESC").paginate(page: params[:page], per_page: 10)
    @rating = @shop.calculate_rating(params[:id])

    render :partial => 'reviews' , locals: {reviews: @reviews, media: @rating}
  end

  def review_images
    # find review and get all amages
    @review = @shop.reviews.find(params[:review_id])
    render :partial => 'review_images'
  end

  def create_review_from_form
    Review.parse_data_and_create_review(params)
  end

  def router
    self.send(params[:method])
  end

  private

    def verify_signature
      query_string = request.query_string
      query_hash = Rack::Utils.parse_query(query_string)
      signature = query_hash.delete("signature")
      sorted_params = query_hash.collect{ |k, v| "#{k}=#{Array(v).join(',')}" }.sort.join
      calculated_signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), ENV['SHOPIFY_API_SECRET'], sorted_params)
      raise 'Invalid signature' unless ActiveSupport::SecurityUtils.secure_compare(signature, calculated_signature)
      @shop = Shop.find_by(shopify_domain: query_hash['shop'])
    end
end