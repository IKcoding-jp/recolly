# テスト計画: メール+パスワード認証機能

Issue: #14

## テスト対象

### Backend（RSpec request spec）
| 対象 | テストファイル | テスト種別 |
|------|-------------|----------|
| ユーザー登録 | `spec/requests/api/v1/registrations_spec.rb` | request spec |
| ログイン/ログアウト | `spec/requests/api/v1/sessions_spec.rb` | request spec |
| パスワードリセット | `spec/requests/api/v1/passwords_spec.rb` | request spec |
| Userモデル | `spec/models/user_spec.rb` | model spec |

### Frontend（Vitest + React Testing Library）
| 対象 | テストファイル | テスト種別 |
|------|-------------|----------|
| ログインページ | `src/pages/LoginPage/LoginPage.test.tsx` | コンポーネントテスト |
| 登録ページ | `src/pages/SignUpPage/SignUpPage.test.tsx` | コンポーネントテスト |
| AuthContext | `src/contexts/AuthContext.test.tsx` | ユニットテスト |
| ProtectedRoute | `src/components/ProtectedRoute/ProtectedRoute.test.tsx` | コンポーネントテスト |
| APIクライアント | `src/lib/api.test.ts` | ユニットテスト |

## テストケース

### Backend: ユーザー登録（POST /api/v1/signup）
- [ ] 正常系: 有効なemail, password, usernameで登録成功（201）
- [ ] 正常系: レスポンスにユーザー情報が含まれる（passwordは含まない）
- [ ] 異常系: emailが空 → バリデーションエラー（422）
- [ ] 異常系: emailの形式が不正 → バリデーションエラー（422）
- [ ] 異常系: 既に登録済みのemail → バリデーションエラー（422）
- [ ] 異常系: passwordが短すぎる → バリデーションエラー（422）
- [ ] 異常系: passwordが空 → バリデーションエラー（422）

### Backend: ログイン（POST /api/v1/login）
- [ ] 正常系: 正しいemail + passwordでログイン成功（200）
- [ ] 正常系: レスポンスにユーザー情報が含まれる
- [ ] 正常系: セッションCookieがセットされる
- [ ] 異常系: 存在しないemail → 認証エラー（401）
- [ ] 異常系: パスワードが間違い → 認証エラー（401）
- [ ] 異常系: emailが空 → 認証エラー（401）

### Backend: ログアウト（DELETE /api/v1/logout）
- [ ] 正常系: ログイン済みユーザーがログアウト成功（200）
- [ ] 正常系: セッションが破棄される
- [ ] 異常系: 未ログイン状態でログアウト → エラー（401）

### Backend: パスワードリセット（POST /api/v1/password）
- [ ] 正常系: 登録済みemailでリセットメール送信リクエスト成功（200）
- [ ] 異常系: 未登録email → エラーまたは成功レスポンス（セキュリティ上、登録有無を漏らさない設計も検討）

### Backend: 認証チェック
- [ ] 正常系: ログイン済みで認証必須エンドポイントにアクセス → 成功（200）
- [ ] 異常系: 未ログインで認証必須エンドポイントにアクセス → 401

### Backend: Userモデル
- [ ] 正常系: 有効な属性でUserが作成できる
- [ ] 異常系: emailなしでバリデーションエラー
- [ ] 異常系: 重複emailでバリデーションエラー
- [ ] 異常系: passwordなしでバリデーションエラー

### Frontend: ログインページ
- [ ] 正常系: フォーム（email, password）が表示される
- [ ] 正常系: 入力して送信→APIが呼ばれる
- [ ] 正常系: ログイン成功→リダイレクト
- [ ] 異常系: エラー時にエラーメッセージが表示される
- [ ] リンク: 「アカウントを作成」リンクが登録ページに遷移する

### Frontend: 登録ページ
- [ ] 正常系: フォーム（username, email, password, password確認）が表示される
- [ ] 正常系: 入力して送信→APIが呼ばれる
- [ ] 正常系: 登録成功→リダイレクト
- [ ] 異常系: エラー時にエラーメッセージが表示される

### Frontend: AuthContext
- [ ] 正常系: ログイン後にisAuthenticatedがtrueになる
- [ ] 正常系: ログアウト後にisAuthenticatedがfalseになる
- [ ] 正常系: 初回ロード時にセッション確認APIが呼ばれる

### Frontend: ProtectedRoute
- [ ] 正常系: 認証済みユーザーはページを表示できる
- [ ] 異常系: 未認証ユーザーはログインページにリダイレクトされる
