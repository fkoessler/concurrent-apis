class SearchResultStreamer
  def initialize(search, sse, stream, view_context)
    @search = search
    @sse = sse
    @stream = stream
    @view = view_context
  end

  def stream
    listener = PgNotifyListener.new("new_search_result")

    loop do
      break if @stream.closed?

      listener.wait(1) do |_channel, _pid, raw_payload|
        payload = JSON.parse(raw_payload, symbolize_names: true)
        next unless payload[:search_id] == @search.id

        search_result = SearchResult.find(payload[:search_result_id])
        html = @view.render(partial: "searches/search_result",
                            locals: { search_result: })
        @sse.write(@view.turbo_stream.append("search_results", html))
      end

      break if @stream.closed?
    end
  rescue ActionController::Live::ClientDisconnected, IOError, PG::ConnectionBad
    # Client disconnected — clean exit
  ensure
    listener.close
  end
end
