class ErrorsController < ApplicationController
  skip_before_action :find_shop_and_verify_token
  
  def show
  end
end
