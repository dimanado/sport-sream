class AccountsController < Merchants::ApplicationController
  before_filter :authenticate_merchant!
  def show
    unless current_merchant.is_admin?
      @transactions = @account.transactions
    else
      #in case we are editing from admin
      redirect_to edit_admin_merchant_path(params[:customer_reference])
    end
  end

end
