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
    listener = PgNotifyListener.new("new_search_result")

    # When the client disconnects, close the PG connection to unblock
    # wait_for_notify immediately, freeing the Puma thread.
    begin
      listen_for_results(sse, listener)
    rescue ActionController::Live::ClientDisconnected, IOError, PG::ConnectionBad
      # Client navigated away or connection dropped — clean exit
    ensure
      listener.close
      sse.close
    end
  end

  private

  def listen_for_results(sse, listener)
    loop do
      break if response.stream.closed?

      listener.wait(1) do |_channel, _pid, raw_payload|
        payload = JSON.parse(raw_payload, symbolize_names: true)
        next unless payload[:search_id] == @search.id

        search_result = SearchResult.find(payload[:search_result_id])
        html = render_to_string(partial: "searches/search_result",
                                locals: { search_result: },
                                formats: [:html])
        sse.write(turbo_stream.append("search_results", html))
      end

      break if response.stream.closed?
    end
  end

  def search_params
    params.require(:search).permit(:origin, :destination, :date)
  end
end
