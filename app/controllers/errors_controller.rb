class ErrorsController < ApplicationController
  layout 'sign_pages'
  def error_404
   @not_found_path = params[:not_found]
   render status: 404
  end
  def error_500
   render status: 500
  end
end