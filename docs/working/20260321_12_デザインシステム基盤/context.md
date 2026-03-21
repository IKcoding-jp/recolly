# コンテキスト: デザインシステム基盤の構築（フェーズ0b）

Issue: #12

## 仕様書参照
- [メイン仕様書](../../superpowers/specs/2026-03-20-recolly-design.md)（セクション7: UIデザイン）
- [ADR-0006](../../adr/0006-cssスタイリング方式にcss-modules-グローバルcss変数を採用.md)

## このIssueで実現すること
仕様書セクション7のデザイン方針（エディトリアルスタイル）に基づき、CSS変数によるデザイントークンと基本UIコンポーネント4種（Typography, Button, Divider, SectionTitle）を実装する。フェーズ1以降の全ページがこのデザインシステムを使って構築される前提。

## このIssue固有の補足
- CSSスタイリング方式: CSS Modules + グローバルCSS変数（ADR-0006で決定）
- フォント: Fraunces（見出し）+ Zen Kaku Gothic New（本文）— Google Fontsから読み込み
- ディレクトリ構成:
  - `frontend/src/styles/tokens.css` — デザイントークン一元定義
  - `frontend/src/components/ui/{Component}/` — 各コンポーネント（tsx + module.css + test.tsx）
- 既存の `index.css` はViteボイラープレート → 全面置き換え
- 既存の `App.css` も不要になるため削除対象
- `index.html` の lang属性を "ja" に変更、タイトルを "Recolly" に変更

## スコープ外
- Card, Badge, NavBar, Input/Form, Rating, ProgressBar, Discussion（フェーズ1以降で実装）
- ダークモード対応（仕様書に記載なし、現時点では不要）
- レスポンシブ対応の詳細（基本的なフォントサイズ調整のみ含む）
