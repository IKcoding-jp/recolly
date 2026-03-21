# frozen_string_literal: true

module ExternalApis
  class IgdbAdapter < BaseAdapter
    IGDB_URL = 'https://api.igdb.com/v4'
    TWITCH_TOKEN_URL = 'https://id.twitch.tv/oauth2/token'
    IMAGE_BASE_URL = 'https://images.igdb.com/igdb/image/upload/t_cover_big'
    # キャッシュキーにクライアントIDを含めて複数環境での衝突を防ぐ
    TOKEN_CACHE_KEY = 'igdb_access_token'
    SEARCH_FIELDS = 'name,summary,cover.image_id,platforms.name,genres.name,first_release_date'

    def media_types
      %w[game]
    end

    def search(query)
      # ユーザー入力のダブルクオート・セミコロンをエスケープ（IGDBクエリ言語の構文破壊防止）
      sanitized = query.gsub('"', '\\"').gsub(';', '')
      body = "search \"#{sanitized}\"; fields #{SEARCH_FIELDS}; limit 20;"
      response = igdb_connection.post('/v4/games', body)

      (response.body || []).map { |item| normalize(item) }
    end

    private

    def igdb_connection
      token = access_token
      client_id = ENV.fetch('IGDB_CLIENT_ID')

      Faraday.new(url: IGDB_URL) do |f|
        f.request :json
        f.response :json
        f.headers['Authorization'] = "Bearer #{token}"
        f.headers['Client-ID'] = client_id
        f.adapter Faraday.default_adapter
      end
    end

    def access_token
      Rails.cache.fetch(TOKEN_CACHE_KEY, expires_in: 50.days) do
        params = {
          client_id: ENV.fetch('IGDB_CLIENT_ID'),
          client_secret: ENV.fetch('IGDB_CLIENT_SECRET'),
          grant_type: 'client_credentials'
        }
        response = Faraday.post(TWITCH_TOKEN_URL, params)
        JSON.parse(response.body)['access_token']
      end
    end

    def normalize(item)
      cover_id = item.dig('cover', 'image_id')

      SearchResult.new(
        item['name'],
        'game',
        item['summary'],
        cover_id ? "#{IMAGE_BASE_URL}/#{cover_id}.jpg" : nil,
        nil,
        item['id'].to_s,
        'igdb',
        {
          platforms: item['platforms']&.pluck('name'),
          genres: item['genres']&.pluck('name'),
          first_release_date: item['first_release_date']
        }.compact
      )
    end
  end
end
