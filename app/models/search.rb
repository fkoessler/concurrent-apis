class Search < ApplicationRecord
  has_many :search_results,
           class_name: "SearchResult",
           inverse_of: :search,
           dependent: :destroy

  validates :origin, presence: true
  validates :destination, presence: true
  validates :date, presence: true
end