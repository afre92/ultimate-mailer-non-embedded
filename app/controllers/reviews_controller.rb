class ReviewsController < ApplicationController
  skip_before_action :find_shop_and_verify_token
  before_action :validate_uuid

  def update
    if @review.update(review_params)
      render json: 'thank you for your review'
    else
      # render error page
    end
  end

  def edit
    # find better way to get this done
    
    order_item = OrderItem.find(@review.order_item_id)
    order = Order.find(order_item.order_id)
    @shop = Shop.find(order.shop_id)
    
    @review_template = @shop.templates.find_by(template_type: 'review')

    review_html = Nokogiri::HTML(@review_template.html)
    @customer = JSON.parse(order.customer, object_class: OpenStruct)
    div = review_html.css('div.email-row-container').last
    review_form = view_context.render partial: 'reviews/review_form.html.erb', locals: { review: @review, shop: @shop }
    div.add_next_sibling(review_form)
    
    @review_template.html = review_html.to_html
    @review_template.html.gsub!('{{', '<%=').gsub!('}}', '%>')

  end

  def show
    #TODO: find better way to link reivew with email
    @email = @review.order.emails.find_by(email_type: 1)
    render layout: false
  end

  private
    def validate_uuid
      @review = Review.find_by(uuid: params[:uuid])
      if @review.nil?
        return redirect_to not_found_path
      elsif @review.review_status == "pending"
        render json: 'Your review has already been submitted, thank you!'
        # redirect_to thank you for submitting you review page
      end
      # find email and find the status of review
    end


    def review_params
      params.require(:review).permit(:rating, :title, :description, :review_status)
    end
end
  


