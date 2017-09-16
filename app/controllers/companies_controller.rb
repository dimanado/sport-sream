class CompaniesController < ApplicationController
  def index
    if params['category_id']
      @companies = Category.find(params['category_id']).companies
    elsif params['city'].try(:[], 'geo_city')
      @companies = Location.near(params['city']['geo_city'], 20).inject([]) {|sum, n| sum << n.company}
    else
      @companies = Company.all
    end
  end

  def show
    @company = Company.find(params[:id])
  end
end
