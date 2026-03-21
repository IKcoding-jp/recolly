# CI/CD + ブランチ保護 設計仕様書

## 概要

GitHub Actions によるCI パイプラインと、mainブランチの保護ルールを設定する。PRベースの開発フローを強制し、lint・テスト・セキュリティスキャンが全てパスしないとマージできない仕組みを構築する。

## トリガー

- `pull_request`（全ブランチからmainへのPR）

## ワークフロー構成

`.github/workflows/ci.yml` に1ファイルで定義。以下5ジョブを並列実行：

### backend-lint

- **実行環境:** ubuntu-latest
- **手順:**
  1. チェックアウト
  2. Ruby 3.3 セットアップ（bundler-cache有効）
  3. `bundle exec rubocop` 実行
- **作業ディレクトリ:** `backend/`

### backend-test

- **実行環境:** ubuntu-latest
- **サービスコンテナ:** PostgreSQL 16
- **手順:**
  1. `libpq-dev` インストール
  2. チェックアウト
  3. Ruby 3.3 セットアップ（bundler-cache有効）
  4. `bin/rails db:test:prepare` 実行
  5. `bundle exec rspec` 実行
- **環境変数:**
  - `RAILS_ENV: test`
  - `DB_HOST: localhost`
  - `DB_USERNAME: postgres`
  - `DB_PASSWORD: postgres`
- **作業ディレクトリ:** `backend/`

### frontend-lint

- **実行環境:** ubuntu-latest
- **手順:**
  1. チェックアウト
  2. Node 22 セットアップ（npm cache有効）
  3. `npm ci` 実行
  4. `npm run lint` 実行
  5. `npm run format:check` 実行
- **作業ディレクトリ:** `frontend/`

### frontend-test

- **実行環境:** ubuntu-latest
- **手順:**
  1. チェックアウト
  2. Node 22 セットアップ（npm cache有効）
  3. `npm ci` 実行
  4. `npm test` 実行
- **作業ディレクトリ:** `frontend/`

### security

- **実行環境:** ubuntu-latest
- **手順:**
  1. チェックアウト
  2. Ruby 3.3 セットアップ（bundler-cache有効）
  3. Node 22 セットアップ
  4. `bundle exec brakeman --no-pager` 実行（backend/）
  5. `bundle exec bundler-audit check --update` 実行（backend/）
  6. `npm audit --audit-level=high` 実行（frontend/）

## ブランチ保護ルール（GitHub設定）

リポジトリ: `IKcoding-jp/recolly` の `main` ブランチに適用。

| 設定 | 値 |
|------|-----|
| Require a pull request before merging | ON |
| Required number of approvals | 0 |
| Require status checks to pass before merging | ON |
| Status checks that are required | backend-lint, backend-test, frontend-lint, frontend-test, security |
| Require branches to be up to date before merging | ON |
| Do not allow bypassing the above settings | OFF |

## 既存ファイルの整理

- `backend/.github/workflows/ci.yml` → 削除（ルートのCI に統合）
- `backend/.github/dependabot.yml` → 削除（必要なら後日ルートに再設定）

## ファイル構成

```
recolly/
├── .github/
│   └── workflows/
│       └── ci.yml
└── backend/
    └── .github/  ← 削除
```
