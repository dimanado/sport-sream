class Merchants::CompaniesController < ApplicationController
  before_filter :get_company, :except => %w[index new create]

  def index
    @companies = current_merchant.companies.all
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(params[:company])
    @company.merchants << current_merchant
    if @company.save
      @company.categories << Category.where(id: params[:company][:categories])
      flash[:success] = "Created #{@company.title}!"
      redirect_to merchants_companies_path
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
      @company.categories << Category.where(id: params[:company][:categories])
      redirect_to merchants_companies_path(@company), :flash => { :success => "Company saved" }
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
