class Merchants::CompaniesController < ApplicationController
  before_filter :get_company, :except => %w[index new create]

  def index
    @companies = current_merchant.companies.all
    puts @companies.count
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(params[:company])
    @company.merchants << current_merchant
    if @company.save
      flash[:success] = "Created #{@company.title}!"
      redirect_to merchants_companies_path ###change
    else
      flash.now[:error] = "Failed to create company"
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @company.update_attributes(params[:company])
      redirect_to edit_merchants_company_path(@company) , :flash => { :success => "Profile complete" }
    else
      flash.now[:error] = "Failed to save company"
      render :edit
    end
  end

  def destroy
    @company.destroy
    flash[:notice] = "Company has been removed."
    redirect_to(params[:redirect_to] || :back)
  end

  private

  def get_company
    @company ||= Company.find(params[:id])
  end
end
