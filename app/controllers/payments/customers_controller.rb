class Payments::CustomersController < ApplicationController
  before_filter :authenticate_consumer!
  before_filter :fetch_customer, except: [:new, :create]

  def show
    if @customer.nil?
      redirect_to :new
    end
  end

  def new

  end

  def create #params[:customer]
    result = Braintree::Customer.create(
      id: params[:id],
      first_name: params[:first_name],
      last_name: params[:last_name],
      phone: params[:phone],
      fax: params[:fax],
      website: params[:website],
      :credit_card => {
        :token => "credit_card_123"
      }
    )
    if result.success?
      redirect_to
    else
      p result.errors
    end
  end

  def edit
  end

  def update
    result = Braintree::Customer.update(
      "a_customer_id", # id of customer to update
      :first_name => "New First Name",
      :last_name => "New Last Name"
    )
    if result.success?
      puts "customer successfully updated"
    else
      p result.errors
    end
  end

  def client_token
  end

  private

  def fetch_customer
    @consumer = Consumer.find(params[:id])
    @customer = Braintree::Customer.find(braintree_customer_id)
    @credit_card = @customer.credit_cards[0].token
  end

end
