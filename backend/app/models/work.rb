# frozen_string_literal: true

class Work < ApplicationRecord
  has_many :records, dependent: :destroy

  # 仕様書セクション4.3: media_type enum
  enum :media_type, {
    anime: 0,
    movie: 1,
    drama: 2,
    book: 3,
    manga: 4,
    game: 5
  }

  validates :title, presence: true
  validates :media_type, presence: true
  validates :external_api_id, uniqueness: { scope: :external_api_source },
                              allow_nil: true
end
