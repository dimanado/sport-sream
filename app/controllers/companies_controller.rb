class CompaniesController < ApplicationController
  def index
    if params['category_id']
      @companies = Category.find(params['category_id']).companies
    else
      @companies = Company.all
    end
  end

  def show
    @company = Company.find(params[:id])
  end
end
