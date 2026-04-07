class FetchProviderTicketsJob < ApplicationJob
  queue_as :default

  def perform(search_id:, provider_id:, origin:, destination:, date:)
    search = Search.find(search_id)
    provider = Provider.find(provider_id)

    results = ProviderAdapter.new(provider).fetch_tickets(origin, destination, date)

    search.results.create!(
      provider: provider,
      data: results['data']
    )
  end
end
