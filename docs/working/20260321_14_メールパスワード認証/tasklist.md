# タスクリスト: メール+パスワード認証機能

Issue: #14

## フェーズ1: バックエンド基盤セットアップ
- [ ] devise + rack-cors を Gemfile に追加し bundle install
- [ ] devise の初期設定（rails generate devise:install → 設定ファイル調整）
- [ ] セッション用ミドルウェアを application.rb に追加
- [ ] CORS設定（config/initializers/cors.rb）
- [ ] User モデル作成（devise generator + 仕様書に基づくカラム追加）
- [ ] usersテーブルのマイグレーション作成・実行

## フェーズ2: バックエンドAPI実装
- [ ] devise ルーティングを `/api/v1/` 配下に設定
- [ ] SessionsController カスタマイズ（JSONレスポンス: ログイン / ログアウト）
- [ ] RegistrationsController カスタマイズ（JSONレスポンス: ユーザー登録）
- [ ] PasswordsController カスタマイズ（JSONレスポンス: パスワードリセット）
- [ ] 認証チェック用エンドポイント（current_user を返す）
- [ ] ApplicationController に認証ヘルパー追加

## フェーズ3: バックエンドテスト
- [ ] RSpec: ユーザー登録（正常系 + 異常系）
- [ ] RSpec: ログイン（正常系 + 異常系）
- [ ] RSpec: ログアウト
- [ ] RSpec: パスワードリセット
- [ ] RSpec: 認証が必要なエンドポイントへの未認証アクセス
- [ ] RuboCop通過確認

## フェーズ4: フロントエンド基盤セットアップ
- [ ] React Router 導入・基本ルーティング設定
- [ ] APIクライアント作成（fetch or axios）
- [ ] 認証コンテキスト（AuthContext / AuthProvider）実装

## フェーズ5: フロントエンドページ実装
- [ ] ログインページ作成（デザインシステムのコンポーネント使用）
- [ ] ユーザー登録ページ作成
- [ ] 認証が必要なルートの保護（ProtectedRoute）
- [ ] 認証後のリダイレクト処理
- [ ] エラー表示（バリデーションエラー、認証エラー）

## フェーズ6: フロントエンドテスト
- [ ] Vitest: ログインページのレンダリング・フォーム送信
- [ ] Vitest: 登録ページのレンダリング・フォーム送信
- [ ] Vitest: AuthContext の状態管理
- [ ] Vitest: ProtectedRoute の未認証時リダイレクト
- [ ] ESLint + Prettier通過確認

## フェーズ7: 結合確認
- [ ] Docker Compose で全体起動して動作確認
- [ ] フロントエンド → バックエンドの認証フロー結合テスト

## 完了条件
- ユーザー登録→ログイン→ログアウトの一連の操作が動作する
- パスワードリセットのAPIが動作する
- 未認証ユーザーが保護されたページにアクセスするとログインページにリダイレクトされる
- バックエンド: RSpec全テストパス + RuboCop通過
- フロントエンド: Vitest全テストパス + ESLint + Prettier通過
