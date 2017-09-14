class PaymentsController < ApplicationController
  before_filter :authenticate_consumer!


end
