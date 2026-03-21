# タスクリスト: デザインシステム基盤の構築（フェーズ0b）

Issue: #12

## フェーズ1: 基盤整備
- [ ] `frontend/src/styles/tokens.css` にデザイントークン定義
  - カラー: ブランドカラー（背景 #fafaf8、テキスト #2c2c2c）、ジャンル別カラー6色
  - タイポグラフィ: フォントファミリー、フォントサイズ（h1〜h4、body、label、meta）
  - スペーシング: 余白の段階（4px, 8px, 12px, 16px, 24px, 32px, 48px, 64px）
  - ボーダー: 区切り線のスタイル（2px solid #2c2c2c）
- [ ] `frontend/index.html` 更新（lang="ja"、title="Recolly"、Google Fonts link追加）
- [ ] `frontend/src/index.css` をグローバルリセット + tokens.css import に置き換え
- [ ] `frontend/src/App.css` を削除、`App.tsx` のimportも削除

## フェーズ2: コンポーネント実装（TDD）
- [ ] Typography コンポーネント
  - テスト → 実装（h1〜h4、body、label、meta の各バリアント）
- [ ] Button コンポーネント
  - テスト → 実装（primary、secondary、ghost の3バリアント）
- [ ] Divider コンポーネント
  - テスト → 実装（太めの区切り線）
- [ ] SectionTitle コンポーネント
  - テスト → 実装（大文字・トラッキング広めの見出し）

## フェーズ3: 確認
- [ ] 全テスト通過確認（`npm test`）
- [ ] lint通過確認（`npm run lint`）
- [ ] App.tsx にサンプル表示を組み込み、ブラウザで視覚確認

## 完了条件
- tokens.css に全デザイントークンが定義されている
- 4コンポーネント全てにテストがあり、全てパスする
- ESLint + Prettier エラーなし
- ブラウザで各コンポーネントの表示を確認できる
