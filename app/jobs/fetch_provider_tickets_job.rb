class FetchProviderTicketsJob < ApplicationJob
  queue_as :default

  def perform(search_id:, provider_id:, origin:, destination:, date:)
    search = Search.find(search_id)
    provider = Provider.find(provider_id)

    # Fetch data from provider API
    results = ProviderAdapter.new(provider).fetch_connections(origin, destination, date)

    # Store results in the search
    search.results.create!(
      provider: provider.name,
      data: results,
      status: "completed"
    )

    # Broadcast Turbo Stream update
    Turbo::StreamsChannel.broadcast_append_to(
      search,
      target: "results",
      partial: "searches/result",
      locals: { results: results, provider: provider.name }
    )
  end
end