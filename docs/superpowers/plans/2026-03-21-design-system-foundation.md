# デザインシステム基盤（フェーズ0b）実装計画

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Recollyのエディトリアルデザインスタイルに基づくCSS変数（デザイントークン）と基本UIコンポーネント4種（Typography, Button, Divider, SectionTitle）を構築する。

**Architecture:** グローバルCSS変数でデザイントークンを一元定義し、各コンポーネントはCSS Modulesでスコープ付きスタイルを持つ。コンポーネントは `frontend/src/components/ui/` に配置し、TDDで実装する。

**Tech Stack:** React 19, TypeScript, CSS Modules, Vitest, React Testing Library

**Issue:** #12
**Working Documents:** `docs/working/20260321_12_デザインシステム基盤/`
**ADR:** `docs/adr/0006-cssスタイリング方式にcss-modules-グローバルcss変数を採用.md`
**仕様書:** `docs/superpowers/specs/2026-03-20-recolly-design.md` セクション7

---

## ファイル構成

```
frontend/
├── index.html                                    # 変更: lang, title, Google Fonts
├── src/
│   ├── index.css                                 # 変更: グローバルリセット + tokens import
│   ├── App.tsx                                   # 変更: ショーケースページ
│   ├── App.css                                   # 削除
│   ├── App.test.tsx                              # 変更: 新しいApp.tsxに合わせる
│   ├── styles/
│   │   └── tokens.css                            # 新規: デザイントークン
│   └── components/
│       └── ui/
│           ├── Typography/
│           │   ├── Typography.tsx                 # 新規
│           │   ├── Typography.module.css          # 新規
│           │   └── Typography.test.tsx            # 新規
│           ├── Button/
│           │   ├── Button.tsx                     # 新規
│           │   ├── Button.module.css              # 新規
│           │   └── Button.test.tsx                # 新規
│           ├── Divider/
│           │   ├── Divider.tsx                    # 新規
│           │   ├── Divider.module.css             # 新規
│           │   └── Divider.test.tsx               # 新規
│           └── SectionTitle/
│               ├── SectionTitle.tsx               # 新規
│               ├── SectionTitle.module.css        # 新規
│               └── SectionTitle.test.tsx          # 新規
```

---

## Task 1: デザイントークン + 基盤整備

**Files:**
- Create: `frontend/src/styles/tokens.css`
- Modify: `frontend/index.html`
- Modify: `frontend/src/index.css`
- Delete: `frontend/src/App.css`
- Modify: `frontend/src/App.tsx` (App.css import除去、最小化)
- Modify: `frontend/src/App.test.tsx` (新しいAppに合わせる)

- [ ] **Step 1: `tokens.css` を作成**

仕様書セクション7.1〜7.2のデザイン方針を全てCSS変数として定義する。

```css
/* frontend/src/styles/tokens.css */

/* === デザイントークン === */
/* Recollyのデザインシステムで使用する全ての値を一元管理する。 */
/* 色・フォント・余白などをハードコードせず、必ずこのファイルの変数を参照すること。 */

:root {
  /* --- カラー --- */
  --color-bg: #fafaf8;
  --color-bg-white: #ffffff;
  --color-text: #2c2c2c;
  --color-text-muted: #6b6b6b;
  --color-border: #2c2c2c;
  --color-border-light: #e0e0e0;

  /* --- ジャンル別カラー --- */
  --color-anime: #3d5a80;
  --color-movie: #5e548e;
  --color-drama: #9f86c0;
  --color-book: #c4956a;
  --color-manga: #e07a5f;
  --color-game: #6b9080;

  /* --- タイポグラフィ --- */
  --font-heading: 'Fraunces', serif;
  --font-body: 'Zen Kaku Gothic New', sans-serif;

  --font-size-h1: 3rem;
  --font-size-h2: 2rem;
  --font-size-h3: 1.5rem;
  --font-size-h4: 1.25rem;
  --font-size-body: 1rem;
  --font-size-label: 0.875rem;
  --font-size-meta: 0.75rem;

  --font-weight-normal: 400;
  --font-weight-medium: 500;
  --font-weight-bold: 700;

  --line-height-tight: 1.2;
  --line-height-normal: 1.6;
  --line-height-relaxed: 1.8;

  /* --- スペーシング --- */
  --spacing-xs: 0.25rem;
  --spacing-sm: 0.5rem;
  --spacing-md: 1rem;
  --spacing-lg: 1.5rem;
  --spacing-xl: 2rem;
  --spacing-2xl: 3rem;
  --spacing-3xl: 4rem;

  /* --- ボーダー --- */
  --border-width: 2px;
  --border-style: solid;

  /* --- トランジション --- */
  --transition-fast: 150ms ease;
  --transition-normal: 250ms ease;
}
```

- [ ] **Step 2: `index.html` を更新**

```html
<!doctype html>
<html lang="ja">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,400;9..144,500;9..144,700&family=Zen+Kaku+Gothic+New:wght@400;500;700&display=swap"
      rel="stylesheet"
    />
    <title>Recolly</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
```

- [ ] **Step 3: `index.css` を置き換え**

```css
/* frontend/src/index.css */

/* デザイントークンの読み込み */
@import './styles/tokens.css';

/* グローバルリセット */
*,
*::before,
*::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

html {
  font-size: 16px;
}

body {
  font-family: var(--font-body);
  font-size: var(--font-size-body);
  line-height: var(--line-height-normal);
  color: var(--color-text);
  background-color: var(--color-bg);
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

img {
  max-width: 100%;
  display: block;
}

a {
  color: inherit;
  text-decoration: none;
}

button {
  cursor: pointer;
  font-family: inherit;
}
```

- [ ] **Step 4: `App.css` を削除、`App.tsx` と `App.test.tsx` を最小化**

`App.css` を削除し、`App.tsx` から import を除去。一時的に最小限のコンテンツにする（Task 6でショーケースに差し替え）。

```tsx
// frontend/src/App.tsx
function App() {
  return (
    <div>
      <h1>Recolly</h1>
    </div>
  )
}

export default App
```

```tsx
// frontend/src/App.test.tsx
import { render, screen } from '@testing-library/react'
import App from './App'

describe('App', () => {
  it('エラーなくレンダリングされる', () => {
    render(<App />)
    expect(screen.getByText('Recolly')).toBeInTheDocument()
  })
})
```

- [ ] **Step 5: テスト + lint が通ることを確認**

Run: `docker compose run --rm frontend npm test`
Expected: PASS (App.test.tsx)

Run: `docker compose run --rm frontend npm run lint`
Expected: エラーなし

- [ ] **Step 6: コミット**

```bash
git add frontend/src/styles/tokens.css frontend/index.html frontend/src/index.css frontend/src/App.tsx frontend/src/App.test.tsx
git rm frontend/src/App.css
git commit -m "feat: デザイントークンとグローバルリセットを定義 (#12)"
```

---

## Task 2: Typography コンポーネント（TDD）

**Files:**
- Create: `frontend/src/components/ui/Typography/Typography.test.tsx`
- Create: `frontend/src/components/ui/Typography/Typography.tsx`
- Create: `frontend/src/components/ui/Typography/Typography.module.css`

- [ ] **Step 1: テストを書く**

```tsx
// frontend/src/components/ui/Typography/Typography.test.tsx
import { render, screen } from '@testing-library/react'
import { Typography } from './Typography'

describe('Typography', () => {
  it('h1バリアントがh1タグでレンダリングされる', () => {
    render(<Typography variant="h1">見出し1</Typography>)
    const el = screen.getByText('見出し1')
    expect(el.tagName).toBe('H1')
  })

  it('h2バリアントがh2タグでレンダリングされる', () => {
    render(<Typography variant="h2">見出し2</Typography>)
    const el = screen.getByText('見出し2')
    expect(el.tagName).toBe('H2')
  })

  it('h3バリアントがh3タグでレンダリングされる', () => {
    render(<Typography variant="h3">見出し3</Typography>)
    const el = screen.getByText('見出し3')
    expect(el.tagName).toBe('H3')
  })

  it('h4バリアントがh4タグでレンダリングされる', () => {
    render(<Typography variant="h4">見出し4</Typography>)
    const el = screen.getByText('見出し4')
    expect(el.tagName).toBe('H4')
  })

  it('bodyバリアントがpタグでレンダリングされる', () => {
    render(<Typography variant="body">本文テキスト</Typography>)
    const el = screen.getByText('本文テキスト')
    expect(el.tagName).toBe('P')
  })

  it('labelバリアントがspanタグでレンダリングされる', () => {
    render(<Typography variant="label">ラベル</Typography>)
    const el = screen.getByText('ラベル')
    expect(el.tagName).toBe('SPAN')
  })

  it('metaバリアントがspanタグでレンダリングされる', () => {
    render(<Typography variant="meta">メタ情報</Typography>)
    const el = screen.getByText('メタ情報')
    expect(el.tagName).toBe('SPAN')
  })

  it('as propでHTMLタグを上書きできる', () => {
    render(
      <Typography variant="h1" as="p">
        段落として表示
      </Typography>,
    )
    const el = screen.getByText('段落として表示')
    expect(el.tagName).toBe('P')
  })

  it('追加のclassNameが適用される', () => {
    render(
      <Typography variant="body" className="custom-class">
        テスト
      </Typography>,
    )
    const el = screen.getByText('テスト')
    expect(el.className).toContain('custom-class')
  })
})
```

- [ ] **Step 2: テストが失敗することを確認**

Run: `docker compose run --rm frontend npx vitest run src/components/ui/Typography/Typography.test.tsx`
Expected: FAIL — `Typography` モジュールが存在しない

- [ ] **Step 3: CSS Moduleを作成**

```css
/* frontend/src/components/ui/Typography/Typography.module.css */

/* 見出し系: Fraunces（セリフ体） */
.h1 {
  font-family: var(--font-heading);
  font-size: var(--font-size-h1);
  font-weight: var(--font-weight-bold);
  line-height: var(--line-height-tight);
  color: var(--color-text);
}

.h2 {
  font-family: var(--font-heading);
  font-size: var(--font-size-h2);
  font-weight: var(--font-weight-bold);
  line-height: var(--line-height-tight);
  color: var(--color-text);
}

.h3 {
  font-family: var(--font-heading);
  font-size: var(--font-size-h3);
  font-weight: var(--font-weight-medium);
  line-height: var(--line-height-tight);
  color: var(--color-text);
}

.h4 {
  font-family: var(--font-heading);
  font-size: var(--font-size-h4);
  font-weight: var(--font-weight-medium);
  line-height: var(--line-height-tight);
  color: var(--color-text);
}

/* 本文系: Zen Kaku Gothic New（ゴシック体） */
.body {
  font-family: var(--font-body);
  font-size: var(--font-size-body);
  font-weight: var(--font-weight-normal);
  line-height: var(--line-height-normal);
  color: var(--color-text);
}

.label {
  font-family: var(--font-body);
  font-size: var(--font-size-label);
  font-weight: var(--font-weight-medium);
  line-height: var(--line-height-normal);
  color: var(--color-text);
}

.meta {
  font-family: var(--font-body);
  font-size: var(--font-size-meta);
  font-weight: var(--font-weight-normal);
  line-height: var(--line-height-normal);
  color: var(--color-text-muted);
}
```

- [ ] **Step 4: コンポーネントを実装**

```tsx
// frontend/src/components/ui/Typography/Typography.tsx
import type { ReactNode, ElementType } from 'react'
import styles from './Typography.module.css'

type Variant = 'h1' | 'h2' | 'h3' | 'h4' | 'body' | 'label' | 'meta'

/** バリアントごとのデフォルトHTMLタグ */
const DEFAULT_TAG_MAP: Record<Variant, ElementType> = {
  h1: 'h1',
  h2: 'h2',
  h3: 'h3',
  h4: 'h4',
  body: 'p',
  label: 'span',
  meta: 'span',
}

type TypographyProps = {
  variant: Variant
  /** デフォルトのHTMLタグを上書きする */
  as?: ElementType
  className?: string
  children: ReactNode
}

export function Typography({
  variant,
  as,
  className,
  children,
}: TypographyProps) {
  const Tag = as ?? DEFAULT_TAG_MAP[variant]
  const combinedClassName = className
    ? `${styles[variant]} ${className}`
    : styles[variant]

  return <Tag className={combinedClassName}>{children}</Tag>
}
```

- [ ] **Step 5: テストが通ることを確認**

Run: `docker compose run --rm frontend npx vitest run src/components/ui/Typography/Typography.test.tsx`
Expected: PASS — 全9テスト

- [ ] **Step 6: コミット**

```bash
git add frontend/src/components/ui/Typography/
git commit -m "feat: Typographyコンポーネントを実装 (#12)"
```

---

## Task 3: Button コンポーネント（TDD）

**Files:**
- Create: `frontend/src/components/ui/Button/Button.test.tsx`
- Create: `frontend/src/components/ui/Button/Button.tsx`
- Create: `frontend/src/components/ui/Button/Button.module.css`

- [ ] **Step 1: テストを書く**

```tsx
// frontend/src/components/ui/Button/Button.test.tsx
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { Button } from './Button'

describe('Button', () => {
  it('childrenが表示される', () => {
    render(<Button variant="primary">クリック</Button>)
    expect(screen.getByRole('button', { name: 'クリック' })).toBeInTheDocument()
  })

  it('primaryバリアントのCSSクラスが適用される', () => {
    render(<Button variant="primary">ボタン</Button>)
    const button = screen.getByRole('button')
    expect(button.className).toContain('primary')
  })

  it('secondaryバリアントのCSSクラスが適用される', () => {
    render(<Button variant="secondary">ボタン</Button>)
    const button = screen.getByRole('button')
    expect(button.className).toContain('secondary')
  })

  it('ghostバリアントのCSSクラスが適用される', () => {
    render(<Button variant="ghost">ボタン</Button>)
    const button = screen.getByRole('button')
    expect(button.className).toContain('ghost')
  })

  it('クリック時にonClickが呼ばれる', async () => {
    const user = userEvent.setup()
    const handleClick = vi.fn()
    render(
      <Button variant="primary" onClick={handleClick}>
        ボタン
      </Button>,
    )
    await user.click(screen.getByRole('button'))
    expect(handleClick).toHaveBeenCalledTimes(1)
  })

  it('disabled時にクリックが無効化される', async () => {
    const user = userEvent.setup()
    const handleClick = vi.fn()
    render(
      <Button variant="primary" onClick={handleClick} disabled>
        ボタン
      </Button>,
    )
    await user.click(screen.getByRole('button'))
    expect(handleClick).not.toHaveBeenCalled()
  })

  it('disabled時にdisabled属性が設定される', () => {
    render(
      <Button variant="primary" disabled>
        ボタン
      </Button>,
    )
    expect(screen.getByRole('button')).toBeDisabled()
  })

  it('smサイズのCSSクラスが適用される', () => {
    render(
      <Button variant="primary" size="sm">
        ボタン
      </Button>,
    )
    const button = screen.getByRole('button')
    expect(button.className).toContain('sm')
  })

  it('lgサイズのCSSクラスが適用される', () => {
    render(
      <Button variant="primary" size="lg">
        ボタン
      </Button>,
    )
    const button = screen.getByRole('button')
    expect(button.className).toContain('lg')
  })

  it('デフォルトのtype属性がbuttonである', () => {
    render(<Button variant="primary">ボタン</Button>)
    expect(screen.getByRole('button')).toHaveAttribute('type', 'button')
  })

  it('type属性を指定できる', () => {
    render(
      <Button variant="primary" type="submit">
        送信
      </Button>,
    )
    expect(screen.getByRole('button')).toHaveAttribute('type', 'submit')
  })

  it('追加のclassNameが適用される', () => {
    render(
      <Button variant="primary" className="extra">
        ボタン
      </Button>,
    )
    expect(screen.getByRole('button').className).toContain('extra')
  })
})
```

- [ ] **Step 2: テストが失敗することを確認**

Run: `docker compose run --rm frontend npx vitest run src/components/ui/Button/Button.test.tsx`
Expected: FAIL

- [ ] **Step 3: CSS Moduleを作成**

```css
/* frontend/src/components/ui/Button/Button.module.css */

.base {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: var(--spacing-sm);
  font-family: var(--font-body);
  font-weight: var(--font-weight-medium);
  border: var(--border-width) var(--border-style) transparent;
  cursor: pointer;
  transition:
    background-color var(--transition-fast),
    color var(--transition-fast),
    border-color var(--transition-fast);
}

.base:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* --- バリアント --- */

.primary {
  composes: base;
  background-color: var(--color-text);
  color: var(--color-bg-white);
  border-color: var(--color-text);
}

.primary:hover:not(:disabled) {
  opacity: 0.85;
}

.secondary {
  composes: base;
  background-color: transparent;
  color: var(--color-text);
  border-color: var(--color-text);
}

.secondary:hover:not(:disabled) {
  background-color: var(--color-text);
  color: var(--color-bg-white);
}

.ghost {
  composes: base;
  background-color: transparent;
  color: var(--color-text);
  border-color: transparent;
}

.ghost:hover:not(:disabled) {
  text-decoration: underline;
}

/* --- サイズ --- */

.sm {
  font-size: var(--font-size-meta);
  padding: var(--spacing-xs) var(--spacing-sm);
}

.md {
  font-size: var(--font-size-label);
  padding: var(--spacing-sm) var(--spacing-md);
}

.lg {
  font-size: var(--font-size-body);
  padding: var(--spacing-sm) var(--spacing-lg);
}
```

- [ ] **Step 4: コンポーネントを実装**

```tsx
// frontend/src/components/ui/Button/Button.tsx
import type { ReactNode, ButtonHTMLAttributes } from 'react'
import styles from './Button.module.css'

type ButtonVariant = 'primary' | 'secondary' | 'ghost'
type ButtonSize = 'sm' | 'md' | 'lg'

type ButtonProps = {
  variant: ButtonVariant
  size?: ButtonSize
  className?: string
  children: ReactNode
} & Omit<ButtonHTMLAttributes<HTMLButtonElement>, 'className'>

export function Button({
  variant,
  size = 'md',
  className,
  children,
  type = 'button',
  ...rest
}: ButtonProps) {
  const classes = [styles[variant], styles[size], className]
    .filter(Boolean)
    .join(' ')

  return (
    <button className={classes} type={type} {...rest}>
      {children}
    </button>
  )
}
```

- [ ] **Step 5: テストが通ることを確認**

Run: `docker compose run --rm frontend npx vitest run src/components/ui/Button/Button.test.tsx`
Expected: PASS — 全12テスト

- [ ] **Step 6: コミット**

```bash
git add frontend/src/components/ui/Button/
git commit -m "feat: Buttonコンポーネントを実装 (#12)"
```

---

## Task 4: Divider コンポーネント（TDD）

**Files:**
- Create: `frontend/src/components/ui/Divider/Divider.test.tsx`
- Create: `frontend/src/components/ui/Divider/Divider.tsx`
- Create: `frontend/src/components/ui/Divider/Divider.module.css`

- [ ] **Step 1: テストを書く**

```tsx
// frontend/src/components/ui/Divider/Divider.test.tsx
import { render } from '@testing-library/react'
import { Divider } from './Divider'

describe('Divider', () => {
  it('hr要素がレンダリングされる', () => {
    const { container } = render(<Divider />)
    const hr = container.querySelector('hr')
    expect(hr).toBeInTheDocument()
  })

  it('デフォルトのCSSクラスが適用される', () => {
    const { container } = render(<Divider />)
    const hr = container.querySelector('hr')
    expect(hr?.className).toContain('divider')
  })

  it('追加のclassNameが結合される', () => {
    const { container } = render(<Divider className="extra" />)
    const hr = container.querySelector('hr')
    expect(hr?.className).toContain('extra')
  })
})
```

- [ ] **Step 2: テストが失敗することを確認**

Run: `docker compose run --rm frontend npx vitest run src/components/ui/Divider/Divider.test.tsx`
Expected: FAIL

- [ ] **Step 3: CSS Moduleを作成**

```css
/* frontend/src/components/ui/Divider/Divider.module.css */

.divider {
  border: none;
  border-top: var(--border-width) var(--border-style) var(--color-border);
  margin: var(--spacing-xl) 0;
}
```

- [ ] **Step 4: コンポーネントを実装**

```tsx
// frontend/src/components/ui/Divider/Divider.tsx
import styles from './Divider.module.css'

type DividerProps = {
  className?: string
}

export function Divider({ className }: DividerProps) {
  const combinedClassName = className
    ? `${styles.divider} ${className}`
    : styles.divider

  return <hr className={combinedClassName} />
}
```

- [ ] **Step 5: テストが通ることを確認**

Run: `docker compose run --rm frontend npx vitest run src/components/ui/Divider/Divider.test.tsx`
Expected: PASS — 全3テスト

- [ ] **Step 6: コミット**

```bash
git add frontend/src/components/ui/Divider/
git commit -m "feat: Dividerコンポーネントを実装 (#12)"
```

---

## Task 5: SectionTitle コンポーネント（TDD）

**Files:**
- Create: `frontend/src/components/ui/SectionTitle/SectionTitle.test.tsx`
- Create: `frontend/src/components/ui/SectionTitle/SectionTitle.tsx`
- Create: `frontend/src/components/ui/SectionTitle/SectionTitle.module.css`

- [ ] **Step 1: テストを書く**

```tsx
// frontend/src/components/ui/SectionTitle/SectionTitle.test.tsx
import { render, screen } from '@testing-library/react'
import { SectionTitle } from './SectionTitle'

describe('SectionTitle', () => {
  it('childrenが表示される', () => {
    render(<SectionTitle>セクション</SectionTitle>)
    expect(screen.getByText('セクション')).toBeInTheDocument()
  })

  it('h2タグでレンダリングされる', () => {
    render(<SectionTitle>セクション</SectionTitle>)
    const el = screen.getByText('セクション')
    expect(el.tagName).toBe('H2')
  })

  it('デフォルトのCSSクラスが適用される', () => {
    render(<SectionTitle>セクション</SectionTitle>)
    const el = screen.getByText('セクション')
    expect(el.className).toContain('sectionTitle')
  })

  it('追加のclassNameが結合される', () => {
    render(<SectionTitle className="extra">セクション</SectionTitle>)
    const el = screen.getByText('セクション')
    expect(el.className).toContain('extra')
  })
})
```

- [ ] **Step 2: テストが失敗することを確認**

Run: `docker compose run --rm frontend npx vitest run src/components/ui/SectionTitle/SectionTitle.test.tsx`
Expected: FAIL

- [ ] **Step 3: CSS Moduleを作成**

```css
/* frontend/src/components/ui/SectionTitle/SectionTitle.module.css */

.sectionTitle {
  font-family: var(--font-body);
  font-size: var(--font-size-label);
  font-weight: var(--font-weight-medium);
  text-transform: uppercase;
  letter-spacing: 0.15em;
  color: var(--color-text);
  margin-bottom: var(--spacing-lg);
}
```

- [ ] **Step 4: コンポーネントを実装**

```tsx
// frontend/src/components/ui/SectionTitle/SectionTitle.tsx
import type { ReactNode } from 'react'
import styles from './SectionTitle.module.css'

type SectionTitleProps = {
  className?: string
  children: ReactNode
}

export function SectionTitle({ className, children }: SectionTitleProps) {
  const combinedClassName = className
    ? `${styles.sectionTitle} ${className}`
    : styles.sectionTitle

  return <h2 className={combinedClassName}>{children}</h2>
}
```

- [ ] **Step 5: テストが通ることを確認**

Run: `docker compose run --rm frontend npx vitest run src/components/ui/SectionTitle/SectionTitle.test.tsx`
Expected: PASS — 全4テスト

- [ ] **Step 6: コミット**

```bash
git add frontend/src/components/ui/SectionTitle/
git commit -m "feat: SectionTitleコンポーネントを実装 (#12)"
```

---

## Task 6: ショーケースページ + 最終確認

**Files:**
- Modify: `frontend/src/App.tsx`
- Modify: `frontend/src/App.test.tsx`

- [ ] **Step 1: App.tsx をコンポーネントショーケースに差し替え**

全コンポーネントの実際の見た目を確認するためのページ。開発中の確認用であり、後のフェーズでルーティング導入時に差し替える。

```tsx
// frontend/src/App.tsx
import { Typography } from './components/ui/Typography/Typography'
import { Button } from './components/ui/Button/Button'
import { Divider } from './components/ui/Divider/Divider'
import { SectionTitle } from './components/ui/SectionTitle/SectionTitle'

function App() {
  return (
    <div style={{ maxWidth: '800px', margin: '0 auto', padding: '2rem' }}>
      <Typography variant="h1">Recolly デザインシステム</Typography>
      <Typography variant="body">
        コンポーネントショーケース — 全UIパーツの一覧
      </Typography>

      <Divider />

      <SectionTitle>Typography</SectionTitle>
      <Typography variant="h1">見出し1 / Heading 1</Typography>
      <Typography variant="h2">見出し2 / Heading 2</Typography>
      <Typography variant="h3">見出し3 / Heading 3</Typography>
      <Typography variant="h4">見出し4 / Heading 4</Typography>
      <Typography variant="body">
        本文テキスト。Zen Kaku Gothic Newで表示されます。
      </Typography>
      <Typography variant="label">ラベルテキスト</Typography>
      <Typography variant="meta">メタ情報テキスト（小さめ・薄め）</Typography>

      <Divider />

      <SectionTitle>Button</SectionTitle>
      <div style={{ display: 'flex', gap: '1rem', flexWrap: 'wrap' }}>
        <Button variant="primary">プライマリ</Button>
        <Button variant="secondary">セカンダリ</Button>
        <Button variant="ghost">ゴースト</Button>
      </div>
      <div
        style={{
          display: 'flex',
          gap: '1rem',
          flexWrap: 'wrap',
          marginTop: '1rem',
        }}
      >
        <Button variant="primary" size="sm">
          Small
        </Button>
        <Button variant="primary" size="md">
          Medium
        </Button>
        <Button variant="primary" size="lg">
          Large
        </Button>
      </div>
      <div style={{ marginTop: '1rem' }}>
        <Button variant="primary" disabled>
          無効化
        </Button>
      </div>

      <Divider />

      <SectionTitle>Divider</SectionTitle>
      <Typography variant="body">上のセクション</Typography>
      <Divider />
      <Typography variant="body">下のセクション</Typography>

      <Divider />

      <SectionTitle>ジャンル別カラー</SectionTitle>
      <div style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap' }}>
        {(['anime', 'movie', 'drama', 'book', 'manga', 'game'] as const).map(
          (genre) => (
            <span
              key={genre}
              style={{
                backgroundColor: `var(--color-${genre})`,
                color: '#fff',
                padding: '0.25rem 0.75rem',
                fontSize: '0.875rem',
              }}
            >
              {genre}
            </span>
          ),
        )}
      </div>
    </div>
  )
}

export default App
```

- [ ] **Step 2: App.test.tsx を更新**

```tsx
// frontend/src/App.test.tsx
import { render, screen } from '@testing-library/react'
import App from './App'

describe('App', () => {
  it('デザインシステムショーケースが表示される', () => {
    render(<App />)
    expect(
      screen.getByText('Recolly デザインシステム'),
    ).toBeInTheDocument()
  })
})
```

- [ ] **Step 3: 全テスト + lint を実行**

Run: `docker compose run --rm frontend npm test`
Expected: PASS — 全テスト（App + Typography + Button + Divider + SectionTitle）

Run: `docker compose run --rm frontend npm run lint`
Expected: エラーなし

- [ ] **Step 4: ブラウザで視覚確認**

Run: `docker compose up frontend`
ブラウザで `http://localhost:5173` を開き、以下を確認:
- Fraunces フォントが見出しに適用されている
- Zen Kaku Gothic New フォントが本文に適用されている
- 背景色が #fafaf8 になっている
- Button の3バリアント × 3サイズが正しく表示される
- Divider が太めの区切り線として表示される
- SectionTitle が大文字・letter-spacing広めで表示される
- ジャンル別カラーが6色正しく表示される

- [ ] **Step 5: コミット**

```bash
git add frontend/src/App.tsx frontend/src/App.test.tsx
git commit -m "feat: デザインシステムショーケースページを追加 (#12)"
```

- [ ] **Step 6: 不要ファイルの削除を確認**

以下のボイラープレートファイルが不要。残っていれば削除する:
- `frontend/src/assets/react.svg`
- `frontend/src/assets/vite.svg`
- `frontend/src/assets/hero.png`

```bash
git rm frontend/src/assets/react.svg frontend/src/assets/vite.svg frontend/src/assets/hero.png
git commit -m "chore: 不要なボイラープレートファイルを削除 (#12)"
```
