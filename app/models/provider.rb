class Provider < ApplicationRecord
  has_many :search_results,
           class_name: "SearchResult",
           inverse_of: :provider,
           dependent: :nullify
  validates :name, presence: true, uniqueness: true
end