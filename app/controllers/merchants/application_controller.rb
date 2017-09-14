class Merchants::ApplicationController < ApplicationController

  layout :layout_by_resource
  helper_method :current_business

  def login
    render layout: "fullscreen"
  end

  protected

    def layout_by_resource
      if merchant_signed_in?
        "merchants"
      else
        "pages"
      end
    end

end
