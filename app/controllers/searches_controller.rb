class SearchesController < ApplicationController
  def new
    @search = Search.new
  end

  def create
  end

  def show
  end

  private

  def search_params
    params.expect(search: %i[origin destination date])
  end
end
