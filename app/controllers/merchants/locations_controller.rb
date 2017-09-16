class Merchants::LocationsController < ApplicationController
  before_filter :get_company, :except => %w[destroy]
  before_filter :get_location, :except => %w[new create]

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(params[:location])
    @company.locations << @location
    if @location.save
      flash[:success] = "Created #{@location.name}!"
      redirect_to edit_merchants_company_path(@company)
    else
      flash.now[:error] = "Failed to create company"
      render :new
    end
  end

  def edit
  end

  def update
    if @location.update_attributes(params[:location])
      redirect_to edit_merchants_company_path(@company), :flash => { :success => "Location saved" }
    else
      flash.now[:error] = "Failed to save location"
      render :edit
    end
  end

  def destroy
    @location.destroy
    flash[:notice] = "Location has been removed."
    redirect_to(params[:redirect_to] || :back)
  end

  private

  def get_company
    @company ||= Company.find(params[:company_id]) rescue nil
  end

  def get_location
    @location ||= Location.find(params[:id])
  end
end
