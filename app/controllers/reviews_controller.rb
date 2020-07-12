class ReviewsController < ApplicationController
  skip_before_action :find_shop_and_verify_token
  before_action :validate_uuid

  def update
    if @review.update(review_params)
      #create discount and show to user
      # price rule to create discount
      shop = Shop.find(@review.order.shop_id)
      if shop.price_rule.active
        ShopifyAPI::Session.temp(domain: shop.shopify_domain, token: shop.shopify_token, api_version: ShopifyApp.configuration.api_version) do
          byebug
          discount_code = ShopifyAPI::DiscountCode.new(price_rule_id: shop.price_rule.shopify_id, code: DiscountCode.create_unique_code)
          if discount_code.save
            @review.discount_code.create(code: discount_code.code)
          end
         
        end

      render json: 'thank you for your review'
      end
    else
      # render error page
    end
  end

  # submit review on site
  def edit
     # how to pass review id to render on template
    @review_email = @review.order.emails.build({order: @review.order, email_type: 'review', uuid: @review.uuid })
    render layout: false
    
  end

  private
    def validate_uuid
      @review = Review.find_by(uuid: params[:uuid])
      if @review.nil?
        return redirect_to not_found_path
      elsif @review.review_status != "pending"
        render json: 'Your review has already been submitted, thank you!'
        # redirect_to thank you for submitting you review page
      end
      # find email and find the status of review
    end


    def review_params
      params.require(:review).permit(:rating, :title, :description, :review_status)
    end
end
  


