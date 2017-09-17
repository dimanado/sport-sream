class Merchants::StreamsController < ApplicationController
  before_filter :get_location, :except => %w[destroy]
  before_filter :get_stream, :except => %w[new create]

  def new
    @stream = Stream.new
  end

  def create
    @stream = Stream.new(params[:stream])
    @stream.location = @location
    if @stream.save
      flash[:success] = "Created #{@stream.title}!"
      redirect_to edit_merchants_location_path(company_id: @location.company.id, id: @location.id)
    else
      flash.now[:error] = "Failed to create stream"
      render :new
    end
  end

  def edit
  end

  def update
    if @stream.update_attributes(params[:stream])
      redirect_to edit_merchants_location_path(company_id: @location.company.id, id: @location.id), :flash => { :success => "Stream saved" }
    else
      flash.now[:error] = "Failed to save stream"
      render :edit
    end
  end

  def destroy
    @stream.destroy
    flash[:notice] = "Stream has been removed."
    redirect_to(params[:redirect_to] || :back)
  end

  private

  def get_stream
    @stream ||= Stream.find(params[:id])
  end

  def get_location
    @location ||= Location.find(params[:location_id]) rescue nil
  end
end
