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

    sse = SSE.new(response.stream)
    config = ActiveRecord::Base.connection_db_config.configuration_hash
    pg_connection = PG.connect(
      host:     config[:host],
      port:     config[:port],
      dbname:   config[:database],
      user:     config[:username],
      password: config[:password]
    )
    pg_connection.exec("LISTEN new_search_result")

    begin
      loop do
        pg_connection.wait_for_notify(5) do |_channel, _pid, raw_payload|
          payload = JSON.parse(raw_payload, symbolize_names: true)
          next unless payload[:search_id] == @search.id

          search_result = SearchResult.find(payload[:search_result_id])
          sse.write(
            "<turbo-stream action=\"append\" target=\"search_results\">" \
              "<template>" \
              "#{render_to_string(partial: "searches/search_result", locals: { search_result: })}" \
              "</template>" \
              "</turbo-stream>"
          )
        end
      end
    rescue ActionController::Live::ClientDisconnected, IOError, PG::ConnectionBad
      # Client navigated away or connection dropped — clean exit
    ensure
      unless pg_connection.finished?
        pg_connection.exec("UNLISTEN new_search_result")
        pg_connection.close
      end
      sse.close
    end
  end

  private

  def search_params
    params.require(:search).permit(:origin, :destination, :date)
  end
end
