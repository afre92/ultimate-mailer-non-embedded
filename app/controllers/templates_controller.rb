# frozen_string_literal: true

class TemplatesController < ApplicationController
  before_action :find_shop

  def edit; end

  def update
    @saved = @template.update(template_params)
  end

  private

  def find_shop
    if params[:shop] && Shop.find_by(shopify_domain: params[:shop]).present?
      @shop = Shop.find_by(shopify_domain: params[:shop])
      @template = @shop.templates.where(template_type: params[:type]).first
    else
      # render nothing
      render nothing: true, status: :bad_request
    end
  end

  def template_params
    params.require(:template).permit(:from, :subject, :reply_to, :body, :html)
  end
end
