class SearchResult < ApplicationRecord
  include Turbo::Broadcastable

  broadcasts_to ->(search_result) { [search_result.search, :results] },
                inserts_by: :append,
                partial: "searches/search_result"

  belongs_to :search,
             class_name: "Search",
             inverse_of: :results
  belongs_to :provider,
             class_name: "Provider",
             inverse_of: :search_results
  store :data, accessors: [ :departure_time, :arrival_time, :origin_station, :destination_station, :price ], coder: JSON

  validates :data, presence: true
end
