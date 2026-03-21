# frozen_string_literal: true

# CORS設定: フロントエンド（React）からのリクエストを許可する
# credentials: true でセッションCookieの送受信を許可（ADR-0007）
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV.fetch("FRONTEND_URL", "http://localhost:5173")

    resource "*",
      headers: :any,
      methods: %i[get post put patch delete options head],
      credentials: true
  end
end
