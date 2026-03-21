# 設計書: デザインシステム基盤の構築（フェーズ0b）

Issue: #12

## 変更対象ファイル

| ファイル | 変更内容 |
|---------|---------|
| `frontend/index.html` | lang="ja"、title="Recolly"、Google Fonts link追加 |
| `frontend/src/index.css` | ボイラープレート → グローバルリセット + tokens import |
| `frontend/src/App.css` | 削除 |
| `frontend/src/App.tsx` | App.css import削除、サンプル表示に変更 |
| `frontend/src/styles/tokens.css` | 新規: デザイントークン定義 |
| `frontend/src/components/ui/Typography/Typography.tsx` | 新規 |
| `frontend/src/components/ui/Typography/Typography.module.css` | 新規 |
| `frontend/src/components/ui/Typography/Typography.test.tsx` | 新規 |
| `frontend/src/components/ui/Button/Button.tsx` | 新規 |
| `frontend/src/components/ui/Button/Button.module.css` | 新規 |
| `frontend/src/components/ui/Button/Button.test.tsx` | 新規 |
| `frontend/src/components/ui/Divider/Divider.tsx` | 新規 |
| `frontend/src/components/ui/Divider/Divider.module.css` | 新規 |
| `frontend/src/components/ui/Divider/Divider.test.tsx` | 新規 |
| `frontend/src/components/ui/SectionTitle/SectionTitle.tsx` | 新規 |
| `frontend/src/components/ui/SectionTitle/SectionTitle.module.css` | 新規 |
| `frontend/src/components/ui/SectionTitle/SectionTitle.test.tsx` | 新規 |

## 実装方針

### デザイントークン（tokens.css）
```css
:root {
  /* カラー */
  --color-bg: #fafaf8;
  --color-text: #2c2c2c;
  --color-border: #2c2c2c;
  /* ジャンル別 */
  --color-anime: #3d5a80;
  --color-movie: #5e548e;
  --color-drama: #9f86c0;
  --color-book: #c4956a;
  --color-manga: #e07a5f;
  --color-game: #6b9080;
  /* フォント */
  --font-heading: 'Fraunces', serif;
  --font-body: 'Zen Kaku Gothic New', sans-serif;
  /* スペーシング */
  --spacing-xs: 4px;
  --spacing-sm: 8px;
  --spacing-md: 16px;
  --spacing-lg: 24px;
  --spacing-xl: 32px;
  --spacing-2xl: 48px;
  --spacing-3xl: 64px;
}
```

### コンポーネント設計

**Typography**
- Props: `variant` ("h1" | "h2" | "h3" | "h4" | "body" | "label" | "meta"), `as?` (HTMLタグ上書き), `children`
- 各バリアントでフォントファミリー・サイズ・ウェイトが変わる
- 見出し系はFraunces、本文系はZen Kaku Gothic New

**Button**
- Props: `variant` ("primary" | "secondary" | "ghost"), `size?` ("sm" | "md" | "lg"), `children`, `onClick?`, `disabled?`, `type?`
- primary: 背景 #2c2c2c + 白文字、hover時に少し薄く
- secondary: 枠線 2px solid #2c2c2c + #2c2c2c文字、hover時に背景反転
- ghost: テキストのみ、hover時にunderline

**Divider**
- Props: `className?`
- 太めの区切り線（2px solid #2c2c2c）、上下に余白

**SectionTitle**
- Props: `children`, `className?`
- 大文字表示（text-transform: uppercase）、letter-spacing広め、フォントサイズ小さめ

## 影響範囲
- 既存の `index.css` と `App.css` のスタイルが完全に置き換わる
- 今後作成する全コンポーネントはここで定義したCSS変数を参照する

## 関連ADR
- [ADR-0006](../../../adr/0006-cssスタイリング方式にcss-modules-グローバルcss変数を採用.md)
