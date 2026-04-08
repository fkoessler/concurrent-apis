class SearchesController < ApplicationController
  include ActionController::Live

  def new
    @search = Search.new
  end

  def create
    @search = Search.create!(search_params)

    Provider.find_each do |provider|
      FetchProviderTicketsJob.perform_later(
        search_id: @search.id,
        provider_id: provider.id,
        origin: params[:search][:origin],
        destination: params[:search][:destination],
        date: params[:search][:date]
      )
    end

    redirect_to search_path(@search)
  end

  def show
    @search = Search.find(params[:id])
  end

  def stream
    @search = Search.find(params[:id])
    response.headers["Content-Type"] = "text/event-stream"
    response.headers["Cache-Control"] = "no-cache"
    response.headers["X-Accel-Buffering"] = "no"

    sse = SSE.new(response.stream)
    SearchResultStreamer.new(@search, sse, response.stream, view_context).stream
  ensure
    sse.close
  end

  def search_params
    params.require(:search).permit(:origin, :destination, :date)
  end
end
