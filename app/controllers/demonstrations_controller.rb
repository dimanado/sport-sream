class DemonstrationsController < ApplicationController
  layout 'demo'

  def iframe_business_list
    @businesses = Business.select('id,name')
    render :layout => 'pages'
  end
end
