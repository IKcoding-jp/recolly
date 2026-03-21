# コンテキスト: メール+パスワード認証機能

Issue: #14

## 仕様書参照
- [メイン仕様書](../../superpowers/specs/2026-03-20-recolly-design.md)（セクション4.1: Users/UserProvidersテーブル、セクション5: 認証）
- [ADR-0007: 認証アーキテクチャにdevise + セッションCookieを採用](../../adr/0007-認証アーキテクチャにdevise-セッションcookieを採用.md)
- [学習ノート: devise](../../learning/devise.md)

## このIssueで実現すること
deviseを使ったメール+パスワード認証の基盤を構築する。ユーザー登録、ログイン、ログアウト、パスワードリセットの基本フローをバックエンド（Rails API）とフロントエンド（React）の両方で実装する。フェーズ1の全機能の前提となる認証基盤。

## このIssue固有の補足
- **認証方式**: devise + セッションCookie（JWTは使わない）。ADR-0007に詳細記載
- **APIモード対応**: Rails APIモードではセッション機能がデフォルト無効。`ActionDispatch::Cookies` と `ActionDispatch::Session::CookieStore` のミドルウェア追加が必要
- **deviseモジュール**: database_authenticatable, registerable, recoverable, validatable の4つを有効化。他のモジュール（confirmable, lockable等）は別Issueで検討
- **CORS**: フロント（Vite dev server）とバック（Rails）が別ポートで動くため、rack-cors gem での設定が必須。`credentials: true` を指定してCookieを送受信可能にする
- **Usersテーブル**: 仕様書のカラム定義に従う（username, email, password_digest, avatar_url, bio）。ただしUserProvidersテーブルはOAuth対応時（別Issue）に作成
- **AI駆動開発**: IKさんはコードを書かない。Claudeが実装する。車輪の再発明を避け、既存ライブラリを最大限活用する

## スコープ外
- OAuth認証（Google / X）→ 別Issue
- メール確認（confirmable）→ 別Issue
- アカウントロック（lockable）→ 別Issue
- ユーザープロフィール編集画面 → 別Issue
- UserProvidersテーブル → OAuth対応時に作成
