# テスト計画: デザインシステム基盤の構築（フェーズ0b）

Issue: #12

## テスト対象
| 対象 | テストファイル | テスト種別 |
|------|-------------|----------|
| Typography | `src/components/ui/Typography/Typography.test.tsx` | unit test |
| Button | `src/components/ui/Button/Button.test.tsx` | unit test |
| Divider | `src/components/ui/Divider/Divider.test.tsx` | unit test |
| SectionTitle | `src/components/ui/SectionTitle/SectionTitle.test.tsx` | unit test |

## テストケース

### Typography
- [ ] 正常系: 各variant（h1〜h4, body, label, meta）が正しいHTMLタグでレンダリングされる
- [ ] 正常系: `as` propでHTMLタグを上書きできる（例: variant="h1" as="h2"）
- [ ] 正常系: childrenが正しく表示される
- [ ] 正常系: 各variantに対応するCSSクラスが適用される

### Button
- [ ] 正常系: 各variant（primary, secondary, ghost）が正しいCSSクラスでレンダリングされる
- [ ] 正常系: onClickが呼ばれる
- [ ] 正常系: disabled時にクリックが無効化される
- [ ] 正常系: 各size（sm, md, lg）が正しいCSSクラスでレンダリングされる
- [ ] 正常系: type属性が正しく設定される（デフォルト "button"）
- [ ] エッジケース: childrenが空でもクラッシュしない

### Divider
- [ ] 正常系: hr要素がレンダリングされる
- [ ] 正常系: デフォルトのCSSクラスが適用される
- [ ] 正常系: 追加のclassNameが結合される

### SectionTitle
- [ ] 正常系: childrenが正しく表示される
- [ ] 正常系: デフォルトのCSSクラスが適用される
- [ ] 正常系: 追加のclassNameが結合される
