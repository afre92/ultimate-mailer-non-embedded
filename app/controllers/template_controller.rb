class TemplateController < ApplicationController
  before_action :find_shop

  def edit
  end

  def update
    # respond with ajax
    if @template.update(template_params)
      flash[:notice] = "Post successfully created"
    else
      flash[:alert] = "Post successfully created NOTTTT"
    end

  end

  private

    def find_shop
      if params[:shop] && Shop.find_by(shopify_domain: params[:shop]).present?
        @shop = Shop.find_by(shopify_domain: params[:shop])
        @template = @shop.templates.find(params[:id])
      else
        # render nothing
        return render :nothing => true, :status => :bad_request
      end
    end

    def template_params
      params.require(:template).permit(:from, :subject, :reply_to, :body)
    end
end
