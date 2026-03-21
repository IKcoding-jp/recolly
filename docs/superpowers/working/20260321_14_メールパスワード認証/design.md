# 設計書: メール+パスワード認証機能

Issue: #14

## 変更対象ファイル

### Backend
| ファイル | 変更内容 |
|---------|---------|
| `backend/Gemfile` | devise, rack-cors 追加 |
| `backend/config/application.rb` | セッション用ミドルウェア追加 |
| `backend/config/routes.rb` | deviseルーティング（/api/v1/配下） |
| `backend/config/initializers/devise.rb` | devise設定（新規生成） |
| `backend/config/initializers/cors.rb` | CORS設定（既存ファイルのコメント解除+修正） |
| `backend/app/models/user.rb` | Userモデル（devise + カラム定義） |
| `backend/db/migrate/xxx_devise_create_users.rb` | usersテーブルのマイグレーション |
| `backend/app/controllers/api/v1/sessions_controller.rb` | ログイン/ログアウト（JSON） |
| `backend/app/controllers/api/v1/registrations_controller.rb` | ユーザー登録（JSON） |
| `backend/app/controllers/api/v1/passwords_controller.rb` | パスワードリセット（JSON） |
| `backend/app/controllers/application_controller.rb` | 認証ヘルパー追加 |

### Frontend
| ファイル | 変更内容 |
|---------|---------|
| `frontend/package.json` | react-router-dom 追加（+ APIクライアント） |
| `frontend/src/App.tsx` | React Routerによるルーティング設定 |
| `frontend/src/contexts/AuthContext.tsx` | 認証状態管理（新規） |
| `frontend/src/pages/LoginPage/` | ログインページ（新規） |
| `frontend/src/pages/SignUpPage/` | ユーザー登録ページ（新規） |
| `frontend/src/components/ProtectedRoute/` | 認証ルートガード（新規） |
| `frontend/src/lib/api.ts` | APIクライアント（新規） |

## 実装方針

### Backend

**deviseのAPIモード対応:**
- `ActionDispatch::Cookies` と `ActionDispatch::Session::CookieStore` をミドルウェアに追加
- deviseのコントローラーを継承し、`respond_to :json` でJSONレスポンスに変更
- `devise_for :users` のルーティングを `/api/v1/` 配下にマウント

**Userモデル（仕様書準拠）:**
```
username:    string（ユーザー名）
email:       string（ユニーク制約）
password_digest: deviseが管理（encrypted_password）
avatar_url:  string（アバター画像URL、null可）
bio:         text（自己紹介、null可）
```
※ deviseは `password_digest` ではなく `encrypted_password` カラムを使用する

**CORS設定:**
- 開発環境: `http://localhost:5173`（Vite dev server）を許可
- `credentials: true` でCookieの送受信を許可

### Frontend

**ルーティング構成:**
```
/            → ログインページ（未認証時）/ ダッシュボード（認証時）
/login       → ログインページ
/signup      → ユーザー登録ページ
/dashboard   → ダッシュボード（認証必須）※ 今回は仮ページ
```

**認証状態管理:**
- React Context で `currentUser` と `isAuthenticated` を管理
- AuthProvider でアプリ全体をラップ
- 初回ロード時にセッション確認APIを呼んでログイン状態を復元

**APIクライアント:**
- fetch ベースのラッパー（追加ライブラリ不要）
- `credentials: 'include'` でCookieを自動送信
- ベースURL、エラーハンドリング、JSONパースを共通化

## 影響範囲

- 今後のバックエンド全エンドポイントは `authenticate_user!`（deviseの認証チェック）を前提とする
- フロントエンドの全ページはAuthContext経由で認証状態を参照する
- React Router導入により、今後のページ追加はルーティング定義の追加で行う

## 関連ADR
- [ADR-0007: 認証アーキテクチャにdevise + セッションCookieを採用](../../../adr/0007-認証アーキテクチャにdevise-セッションcookieを採用.md)
