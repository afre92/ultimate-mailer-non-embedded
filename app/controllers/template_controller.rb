class TemplateController < ApplicationController
before_action :find_shop#, only: :edit

  def edit
    @template = @shop.templates.find(params[:template])
  end

  def update
    byebug
  end

  private

    def find_shop
      if params[:shop] && Shop.find_by(shopify_domain: params[:shop]).present?
        @shop = Shop.find_by(shopify_domain: params[:shop])
      else
        # render nothing
        return render :nothing => true, :status => :bad_request
      end
    end
end
