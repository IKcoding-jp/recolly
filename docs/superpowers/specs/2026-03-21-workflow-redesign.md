# ワークフロー見直し — superpowers主軸化

## 目的

開発ワークフローをsuperpowersスキル主軸に統一し、カスタムスキルとの役割重複を解消する。

## 問題

- issue-creatorのブレインストーミングとsuperpowers:brainstormingが二重に動作する
- Working Docs（`docs/working/`）と superpowersドキュメント（`docs/superpowers/`）が二元管理になっている
- pr-reviewの「自分の言葉で説明」はAI駆動開発では形骸化している

## 変更内容

### 1. 開発フロー（CLAUDE.mdに記載）

```
1. superpowers:brainstorming（要件深掘り + スペック作成）
   ├── comprehension-guard（技術選定時に自動発動）
   └── adr（設計判断確定時に自動記録）
2. GitHub Issue作成（issue-creatorスキル：スペック → Issue本文 + Working Docs）
3. superpowers:writing-plans（実装プラン作成）
4. superpowers:subagent-driven-development
   └── 各タスク内で superpowers:test-driven-development
5. superpowers:finishing-a-development-branch → PR作成 → Claude Code Review → マージ
```

### 2. issue-creatorスキルの作り直し

**Before:** ブレインストーミング → コード調査 → Issue作成 → Working Docs生成（全工程を担当）

**After:** brainstormingの結果を受け取り、以下のみ担当
- スペックからIssue本文を生成して `gh issue create`
- `docs/superpowers/working/{YYYYMMDD}_{Issue番号}_{タイトル}/` にWorking Docs生成

ブレインストーミング、コード調査、技術選定はsuperpowersに完全委譲。

### 3. pr-reviewスキルの廃止

superpowersの `finishing-a-development-branch` に置き換え。
pr-reviewのセルフチェック項目はCLAUDE.mdのコードレビュー観点に統合。

### 4. ドキュメント配置の一元化

```
docs/superpowers/
├── specs/      ← brainstormingが生成するスペック
├── plans/      ← writing-plansが生成する実装プラン
└── working/    ← Issue単位のコンテキスト復元用（旧 docs/working/）
```

既存の `docs/working/` は `docs/superpowers/working/` に移動。

### 5. 残すカスタムスキル（4つ）

| スキル | 役割 | 変更 |
|--------|------|------|
| issue-creator | Issue起票 + Working Docs生成 | 薄いラッパーに作り直し |
| comprehension-guard | 技術選定の理解度チェック | 変更なし |
| adr | 設計判断記録 | 変更なし |
| learning-note | 学習ノート作成 | 変更なし |

### 6. CLAUDE.md変更箇所

- 「開発手法」セクションのフローを更新
- issue-creatorへの言及を更新
- Working Docsの配置先を更新
- pr-reviewへの言及を削除
- 「理解負債防止」セクションからpr-review関連を削除

## 作業リスト

- [ ] CLAUDE.mdの開発手法・理解負債防止セクションを更新
- [ ] issue-creatorスキルを作り直し（SKILL.md + references/）
- [ ] pr-reviewスキルを削除
- [ ] `docs/working/` を `docs/superpowers/working/` に移動
- [ ] pr-reviewのセルフチェック項目をCLAUDE.mdに統合
