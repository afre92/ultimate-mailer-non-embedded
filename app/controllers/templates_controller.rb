# frozen_string_literal: true

class TemplatesController < ApplicationController

  def edit
    @template = @shop.templates.where(template_type: params[:type]).first
    @valid_code = Template::VALID_CODE
  end

  def update
    @template = @shop.templates.where(template_type: params[:type]).first
    @saved = @template.update(template_params)
  end

  private

    def template_params
      params.require(:template).permit(:from, :subject, :reply_to, :body, :html)
    end
end
