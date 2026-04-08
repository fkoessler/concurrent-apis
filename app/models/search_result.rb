class SearchResult < ApplicationRecord
  belongs_to :search,
             class_name: "Search",
             inverse_of: :results
  belongs_to :provider,
             class_name: "Provider",
             inverse_of: :search_results
  store :data, accessors: [ :departure_time, :arrival_time, :origin_station, :destination_station, :price ], coder: JSON

  validates :data, presence: true

  after_commit :publish_search_result, on: :create

  private

  def publish_search_result
    payload = { search_result_id: id, search_id: search_id }.to_json
    ActiveRecord::Base.connection.execute(
      ActiveRecord::Base.sanitize_sql(["SELECT pg_notify('new_search_result', ?)", payload])
    )
  end
end
