# CI/CD + ブランチ保護 実装計画

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** GitHub Actions CIパイプラインを構築し、mainブランチの保護ルールを設定。PRベースの開発フローを確立する。

**Architecture:** プロジェクトルートの `.github/workflows/ci.yml` に5ジョブ（backend-lint, backend-test, frontend-lint, frontend-test, security）を定義。GitHub CLI（`gh`）でブランチ保護を設定。

**Tech Stack:** GitHub Actions / GitHub CLI (`gh`)

---

## 仕様書参照

- `docs/superpowers/specs/2026-03-21-ci-cd-branch-protection.md`

## ファイル構成

```
recolly/
├── .github/
│   └── workflows/
│       └── ci.yml          [Task 1]
└── backend/
    └── .github/            [Task 2: 削除]
```

---

### Task 1: GitHub Actions CI ワークフロー作成

**Files:**
- Create: `.github/workflows/ci.yml`

- [ ] **Step 1: ディレクトリ作成**

```bash
mkdir -p .github/workflows
```

- [ ] **Step 2: ci.yml を作成**

`.github/workflows/ci.yml`:

```yaml
name: CI

on:
  pull_request:
    branches: [main]

jobs:
  backend-lint:
    name: Backend Lint
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: backend
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.3'
          bundler-cache: true
          working-directory: backend
      - run: bundle exec rubocop

  backend-test:
    name: Backend Test
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: backend
    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
        ports:
          - 5432:5432
        options: --health-cmd="pg_isready" --health-interval=10s --health-timeout=5s --health-retries=3
    steps:
      - name: Install system dependencies
        run: sudo apt-get update && sudo apt-get install --no-install-recommends -y libpq-dev
        working-directory: .
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.3'
          bundler-cache: true
          working-directory: backend
      - name: Setup database
        env:
          RAILS_ENV: test
          DB_HOST: localhost
          DB_USERNAME: postgres
          DB_PASSWORD: postgres
        run: bin/rails db:test:prepare
      - name: Run tests
        env:
          RAILS_ENV: test
          DB_HOST: localhost
          DB_USERNAME: postgres
          DB_PASSWORD: postgres
        run: bundle exec rspec

  frontend-lint:
    name: Frontend Lint
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: frontend
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '22'
          cache: 'npm'
          cache-dependency-path: frontend/package-lock.json
      - run: npm ci
      - run: npm run lint
      - run: npm run format:check

  frontend-test:
    name: Frontend Test
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: frontend
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '22'
          cache: 'npm'
          cache-dependency-path: frontend/package-lock.json
      - run: npm ci
      - run: npm test

  security:
    name: Security Scan
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.3'
          bundler-cache: true
          working-directory: backend
      - uses: actions/setup-node@v4
        with:
          node-version: '22'
          cache: 'npm'
          cache-dependency-path: frontend/package-lock.json
      - name: Brakeman security scan
        run: bundle exec brakeman --no-pager
        working-directory: backend
      - name: Bundle audit
        run: bundle exec bundler-audit check --update
        working-directory: backend
      - name: npm audit
        run: npm audit --audit-level=high || true
        working-directory: frontend
```

> `npm audit` は `|| true` を付ける。既知の低リスク脆弱性でCIが落ちるのを防ぐため。`--audit-level=high` で高リスクのみ失敗させる。

- [ ] **Step 3: コミット**

```bash
git add .github/workflows/ci.yml
git commit -m "ci: GitHub Actions CIパイプラインを追加"
```

---

### Task 2: 既存の backend/.github を削除

**Files:**
- Delete: `backend/.github/workflows/ci.yml`
- Delete: `backend/.github/dependabot.yml`
- Delete: `backend/.github/`

- [ ] **Step 1: backend/.github を削除**

```bash
rm -rf backend/.github
```

- [ ] **Step 2: コミット**

```bash
git add -A backend/.github
git commit -m "chore: Rails自動生成のCI設定を削除（ルートに統合）"
```

---

### Task 3: リモートにプッシュ + PR作成

- [ ] **Step 1: フィーチャーブランチをプッシュ**

```bash
git push -u origin feature/phase0-dev-environment
```

- [ ] **Step 2: PRを作成**

```bash
gh pr create --title "feat: フェーズ0 開発環境整備" --body "$(cat <<'EOF'
## Summary
- モノレポ構成（backend / frontend / infra）
- Docker Compose環境（Rails API + React + PostgreSQL）
- テストフレームワーク（RSpec + Vitest）
- リンター（RuboCop + ESLint + Prettier）
- ヘルスチェックAPI（TDD）
- CLAUDE.md（プロジェクトルール）
- Git hooks（lefthook）
- GitHub Actions CI（lint + test + security）

## Test plan
- [ ] `docker compose up` で全サービスが起動する
- [ ] RSpec: テスト全パス
- [ ] Vitest: テスト全パス
- [ ] RuboCop: no offenses
- [ ] ESLint: エラーなし
- [ ] GitHub Actions CIが全ジョブパス
EOF
)"
```

- [ ] **Step 3: CIの結果を確認**

```bash
gh pr checks
```

Expected: 全5ジョブがパス

---

### Task 4: ブランチ保護ルール設定

> CIが初回実行されてステータスチェック名がGitHubに登録された後に設定する

- [ ] **Step 1: ブランチ保護を設定**

```bash
gh api repos/IKcoding-jp/recolly/rulesets -X POST --input - <<'EOF'
{
  "name": "main protection",
  "target": "branch",
  "enforcement": "active",
  "conditions": {
    "ref_name": {
      "include": ["refs/heads/main"],
      "exclude": []
    }
  },
  "rules": [
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": 0,
        "dismiss_stale_reviews_on_push": false,
        "require_code_owner_review": false,
        "require_last_push_approval": false,
        "required_review_thread_resolution": false
      }
    },
    {
      "type": "required_status_checks",
      "parameters": {
        "strict_status_checks_policy": true,
        "required_status_checks": [
          { "context": "Backend Lint" },
          { "context": "Backend Test" },
          { "context": "Frontend Lint" },
          { "context": "Frontend Test" },
          { "context": "Security Scan" }
        ]
      }
    }
  ]
}
EOF
```

> GitHub Repository Rulesets API を使用。従来のBranch Protection APIより新しく推奨されている。

- [ ] **Step 2: 設定を確認**

```bash
gh api repos/IKcoding-jp/recolly/rulesets
```

---

### Task 5: CIパス後にマージ

- [ ] **Step 1: CIステータス確認**

```bash
gh pr checks
```

Expected: 全ジョブがパス

- [ ] **Step 2: マージ**

```bash
gh pr merge --squash --delete-branch
```

> `--squash` でフェーズ0の全コミットを1つにまとめてmainにマージ。開発ブランチは自動削除。

---

## 完了条件

- [ ] `.github/workflows/ci.yml` がプロジェクトルートに存在する
- [ ] `backend/.github/` が削除されている
- [ ] GitHub Actions CIが全5ジョブパス
- [ ] mainブランチに保護ルールが設定されている
- [ ] PRがmainにマージされている
