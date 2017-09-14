class DashboardController < Merchants::ApplicationController
  before_filter :authenticate_merchant!

  def index
  end

  def demographics
    group = case params[:group]
      when "subscribers" then (current_business.subscribers - current_business.private_subscribers)
      when "non-subscribers" then current_business.interested_non_subscribers
      when "private-subscribers" then current_business.private_subscribers
    end

    demographics = Target.age_bracket_counts_by_gender(group)
    render :json => {demographics: demographics}
  end

end
