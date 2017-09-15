class StreamsController < ApplicationController
  def show
    @stream = Stream.find(params[:id])
  end
end