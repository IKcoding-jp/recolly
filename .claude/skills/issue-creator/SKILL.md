---
name: issue-creator
description: |
  GitHub Issue作成スキル。superpowers:brainstormingの結果を受けてIssue起票 + Working Docs生成を行う。
  以下の場面で使うこと:
  - 「Issueを作って」「Issue起票」と言われたとき
  - superpowers:brainstormingが完了し、スペックが確定したとき
  ブレインストーミングやコード調査は行わない（superpowersに委譲済み）。
---

# Issue Creator

superpowers:brainstormingの結果（スペック）を受けて、GitHub Issue起票とWorking Docs生成を行う。

⚠️ **このスキルではブレインストーミング・コード調査・技術選定を行わない。それらはsuperpowersに委譲済み。**

## ワークフロー

```
1. スペック確認 → 2. Issue本文作成 → 3. ユーザー確認 → 4. Issue起票 → 5. Working Docs生成
```

---

## Phase 1: スペック確認

brainstormingで作成されたスペック（`docs/superpowers/specs/` 配下）を読み、Issue本文の元情報を整理する。

スペックが存在しない場合は、ユーザーにbrainstormingの実施を提案する。

---

## Phase 2: Issue本文作成

### タイプ判定

Issueタイプを判定: `bug` / `feat` / `refactor` / `docs` / `style` / `perf` / `chore` / `test`

### Issue本文テンプレート

```markdown
## 概要
[何をするか - 1-2文]

## 理由/背景
[なぜ必要か]

## スコープ
- [ ] タスク1
- [ ] タスク2

## 対象外
- 今回は対応しないこと

## 関連
- スペック: `docs/superpowers/specs/YYYY-MM-DD-xxx.md`
- ADR: `docs/adr/XXXX-xxx.md`（あれば）
```

---

## Phase 3: ユーザー確認

Issue本文を提示し、内容が正しいか確認する。

---

## Phase 4: Issue起票

```bash
# ⚠️ 一時ファイルはリポジトリルートに作成（Windows互換のため /tmp/ は使用禁止）
cat > .tmp-issue-body.md <<'EOF'
[Issue本文]
EOF

gh issue create --title "[type]: タイトル" --body-file .tmp-issue-body.md --label "ラベル"
rm -f .tmp-issue-body.md
```

**ラベル対応**: bug→`bug`, feat→`enhancement`, refactor→`refactor`, docs→`documentation`, style→`design`, perf→`performance`, chore→`chore`, test→`testing`

---

## Phase 5: Working Docs生成

### ディレクトリ構成

```
docs/superpowers/working/{YYYYMMDD}_{Issue番号}_{タイトル}/
├── context.md      # コンテキスト復元用（スペックへの参照 + Issue固有の補足）
└── tasklist.md     # タスクリスト
```

⚠️ **context.md はスペックを複製しない。** スペックへのリンク + このIssue固有の補足に留める。
⚠️ **design.md / testing.md は生成しない。** superpowers:writing-plansが実装プランとして担当する。

テンプレートは **[working-templates.md](references/working-templates.md)** を参照。

---

## Phase 6: 完了

```
✅ Issue #XX を作成しました
✅ Working Documents を生成しました
   └── docs/superpowers/working/YYYYMMDD_XX_タイトル/

次のステップ:
  superpowers:writing-plans で実装プランを作成してください。
```
