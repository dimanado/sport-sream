class StockphotosController < ApplicationController
    respond_to :json, :html

  def index
    @stockphotos = Stockphoto.all
    render layout: 'fullscreen'
  end

  def show
    @stockphoto = Stockphoto.find(params[:id])
  end

  def category
    @stockphotos = Stockphoto.find_all_by_category(params[:category])
    render :carousel, layout: false
  end

  def new
    @stockphoto = Stockphoto.new
  end

  def edit
    @stockphoto = Stockphoto.find(params[:id])
  end

  def create
    @stockphoto = Stockphoto.new(params[:stockphoto])

    respond_to do |format|
      if @stockphoto.save
        format.html { redirect_to @stockphoto, notice: 'Stockphoto was successfully created.' }
        format.json { render json: @stockphoto, status: :created, location: @stockphoto }
      else
        format.html { render action: "new" }
        format.json { render json: @stockphoto.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @stockphoto = Stockphoto.find(params[:id])

    respond_to do |format|
      if @stockphoto.update_attributes(params[:stockphoto])
        format.html { redirect_to @stockphoto, notice: 'Stockphoto was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @stockphoto.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @stockphoto = Stockphoto.find(params[:id])
    @stockphoto.destroy

    respond_to do |format|
      format.html { redirect_to stockphotos_url }
      format.json { head :no_content }
    end
  end
end
