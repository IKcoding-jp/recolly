# frozen_string_literal: true

class WorkSearchService
  CACHE_TTL = 30.minutes

  def search(query, media_type: nil)
    cache_key = "work_search:#{media_type || 'all'}:#{query}"

    Rails.cache.fetch(cache_key, expires_in: CACHE_TTL) do
      adapters = select_adapters(media_type)
      adapters.flat_map { |adapter| adapter.safe_search(query) }
    end
  end

  private

  # クラス定数ではなくメソッドで返す（Zeitwerkのオートロード順序問題を回避）
  def adapter_map
    {
      'movie' => ExternalApis::TmdbAdapter,
      'drama' => ExternalApis::TmdbAdapter,
      'anime' => ExternalApis::AniListAdapter,
      'manga' => ExternalApis::AniListAdapter,
      'book' => ExternalApis::GoogleBooksAdapter,
      'game' => ExternalApis::IgdbAdapter
    }
  end

  def select_adapters(media_type)
    if media_type.present?
      adapter_class = adapter_map[media_type]
      adapter_class ? [adapter_class.new] : []
    else
      all_adapters
    end
  end

  def all_adapters
    [
      ExternalApis::TmdbAdapter.new,
      ExternalApis::AniListAdapter.new,
      ExternalApis::GoogleBooksAdapter.new,
      ExternalApis::IgdbAdapter.new
    ]
  end
end
