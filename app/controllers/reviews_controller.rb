class ReviewsController < ApplicationController
  skip_before_action :find_shop_and_verify_token
  before_action :validate_uuid

  def update
    review = @email.review
    if review.update(review_params)
      render json: 'thank you for your review'
    else
      # render error page
    end
  end

  private

    def validate_uuid
      @email = Email.find_by(uuid: params[:uuid])
      if @email.nil? || @email.review.nil?
        return redirect_to not_found_path
      elsif @email.review.review_status != "pending"
        render json: 'Your review has already been submitted, thank you!'
        # redirect_to thank you for submitting you review page
      end
      # find email and find the status of review
    end


    def review_params
      params.require(:review).permit(:rating, :title, :description, :review_status)
    end
end
  


