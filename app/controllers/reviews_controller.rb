class ReviewsController < ApplicationController
  skip_before_action :find_shop_and_verify_token
  before_action :validate_uuid

  def update
    if @review.update(review_params)
      if @review.review_status == 'completed'
        if @shop.price_rule.active
          discount_code = @shop.temp_session(:create_discount_code)
          render json: "Thank you for your review. Your discount code is: #{discount_code.code}"
        else
          render json: 'Thank you for your review.'
        end

      else
        redirect_to action: 'images_upload'
      end

      
    else
      # render error page
    end
  end

  def images_upload
  end


  # submit review on site
  def edit
    @review_email = @review.order.emails.build({order: @review.order, email_type: 'review', uuid: @review.uuid })
    render layout: false
  end

  private

    def validate_uuid
      @review = Review.find_by(uuid: params[:uuid])
      if @review.nil?
        return redirect_to not_found_path
      elsif @review.review_status == "completed"
        render json: 'Your review has already been submitted, thank you!'
        # redirect_to thank you for submitting you review page
      end
      @shop = Shop.find(@review.order.shop_id)
      # find email and find the status of review
    end


    def review_params
      params.require(:review).permit( :rating, :title, :description, :review_status, images: [])
    end
end
  


