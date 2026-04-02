class SearchResult < ApplicationRecord
  belongs_to :search,
             class_name: "Search",
             inverse_of: :search_results
  belongs_to :provider,
             class_name: "Provider",
             inverse_of: :search_results
  store :data, accessors: [:departure_time, :arrival_time, :origin_station, :destination_station, :price], coder: JSON
  validates :data, presence: true
end