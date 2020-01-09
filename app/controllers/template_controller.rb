class TemplateController < ApplicationController
# before_action :find_shop

  def edit
    @template = Template.new
    
  end

  def update
  end

  private

    def find_shop
      # if params[:shop] && Shop.find(params[:shop]).present?
      #   @shop = Shop.find(params[:shop])
      # else
         return render :nothing => true, :status => :bad_request
      # end
    end
end
