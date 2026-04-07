class ProviderAdapter
  PROVIDER_CLIENT_MAPPING = {
    sncf: Providers::Sncf::Client,
    db: Providers::DeutscheBahn::Client,
    trenitalia: Providers::Trenitalia::Client,
    renfe: Providers::Renfe::Client
  }.freeze

  attr_reader :provider

  def initialize(provider)
    @provider = provider
  end

  def fetch_tickets(origin, destination, date)
    client.fetch_tickets(origin:, destination:, date:)
  end

  private

  def client
    @client ||= PROVIDER_CLIENT_MAPPING[provider.code.to_sym].new
  end
end
