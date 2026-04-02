class SearchesController < ApplicationController
  def new
    @search = Search.new
  end

  def create
    @search = Search.create!(search_params)

    Provider.find_each do |provider|
      FetchProviderTicketsJob.perform_later(
        search_id: @search.id,
        carrier_id: provider.id,
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

  private

  def search_params
    params.expect(search: %i[origin destination date])
  end
end
