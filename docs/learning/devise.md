# devise（Rails認証ライブラリ）

## これは何か

Railsアプリケーションに「ユーザー登録」「ログイン」「ログアウト」「パスワードリセット」などの認証機能をまとめて追加してくれるライブラリ（gem）。
例えるなら、マンションのオートロックシステム一式（鍵の発行、入退室管理、鍵の紛失対応、不正侵入防止）をパッケージで導入するイメージ。

## もう少し詳しく

### モジュール方式（必要な機能を選んで使う）

deviseの最大の特徴は「モジュール方式」。認証に関する機能が個別のモジュール（＝部品）に分かれていて、必要なものだけ選んで有効にできる。

| モジュール名 | 何をしてくれるか | 例え |
|-------------|----------------|------|
| **database_authenticatable** | パスワードをハッシュ化（暗号化）してDBに保存し、ログイン時に照合する | 鍵の発行と照合 |
| **registerable** | ユーザー登録（サインアップ）の機能 | 入居手続き |
| **recoverable** | 「パスワードを忘れた」→メールでリセットリンクを送る | 鍵の紛失時の再発行 |
| **rememberable** | 「ログイン状態を維持する」（Remember Me）機能 | 顔パス登録 |
| **validatable** | メールアドレスの形式チェック、パスワードの長さチェック | 入居審査 |
| **lockable** | パスワードを何回も間違えるとアカウントをロックする | 不正侵入防止の自動ロック |
| **timeoutable** | 一定時間操作しないと自動ログアウト | 一定時間で自動施錠 |
| **trackable** | ログイン回数、最終ログイン日時、IPアドレスを記録 | 入退室ログ |
| **confirmable** | 登録時に確認メールを送り、メールアドレスの所有を確認する | 本人確認書類の提出 |
| **omniauthable** | Google、X（Twitter）などの外部サービスでログイン（OAuth連携） | 他のマンションの鍵で入れる提携 |

Recollyのフェーズ1（MVP）では、まず以下を使う予定:
- `database_authenticatable`（ログイン）
- `registerable`（ユーザー登録）
- `recoverable`（パスワードリセット）
- `validatable`（入力チェック）

### deviseが自動で作ってくれるもの

deviseを導入すると、以下が自動で用意される:

**1. ルーティング（URLの定義）**
```
POST   /users/sign_in    → ログイン
DELETE /users/sign_out   → ログアウト
POST   /users            → ユーザー登録
PUT    /users/password    → パスワードリセット
```
これらのURLを自分で定義する必要がない。

**2. コントローラー（リクエストを処理するロジック）**
ログイン処理、登録処理、パスワードリセット処理などのロジックが内蔵されている。
必要に応じてカスタマイズ（上書き）もできる。

**3. Userモデルへの機能追加**
```ruby
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable
end
```
この1行で、Userモデルにパスワードの暗号化・照合・バリデーションなどのメソッドが追加される。

### セッションCookieでの動作の流れ

```
1. ユーザーがメールアドレスとパスワードを送信
       ↓
2. deviseがDBでメールアドレスを検索
       ↓
3. パスワードをハッシュ化して、DBのハッシュ値と照合
       ↓
4. 一致 → セッションを作成し、Cookieをブラウザに返す
   不一致 → エラーを返す
       ↓
5. 以降のリクエストでは、ブラウザが自動でCookieを送る
       ↓
6. deviseがCookieからセッション情報を読み取り、ログイン済みユーザーを特定
```

### APIモードでの注意点

Railsの「APIモード」は、HTMLを返さずJSONだけを返す軽量な設定。
deviseはもともとHTMLを返す前提で作られているため、APIモードでは以下の調整が必要:

1. **セッション用ミドルウェアの追加**: APIモードではセッション機能が無効なので、有効にする
2. **JSONレスポンスへの変更**: deviseのコントローラーをカスタマイズして、HTMLではなくJSONを返すようにする
3. **CSRFトークンの扱い**: APIモードではCSRF（＝別サイトからの不正リクエスト）対策の方法が異なる

## Recollyでどう使っているか

※ フェーズ1で実装予定。以下は予定されるファイル構成:

- `backend/Gemfile` — `gem 'devise'` を追加
- `backend/config/initializers/devise.rb` — deviseの設定ファイル（セッションの有効期限、パスワードの最小文字数など）
- `backend/app/models/user.rb` — `devise :database_authenticatable, :registerable, ...` でモジュールを指定
- `backend/config/application.rb` — セッション用ミドルウェアの追加
- `backend/app/controllers/` — devise のコントローラーをカスタマイズ（JSON レスポンス対応）

## なぜこれを選んだか

→ [ADR-0007: 認証アーキテクチャにdevise + セッションCookieを採用](../adr/0007-認証アーキテクチャにdevise-セッションcookieを採用.md)

要点:
- AI駆動開発のため、車輪の再発明を避け既存ライブラリを活用する方針
- パスワードリセット、アカウントロック等が最初から揃っている
- 将来のOAuth対応時もomniauthableモジュールで拡張可能
- 将来のモバイル/API対応時はdevise-jwtを追加で対応（セッション認証との並行運用）

## 注意点・ハマりやすいポイント

- **APIモードではそのまま動かない**: セッション用ミドルウェアの追加とJSONレスポンスへのカスタマイズが必要
- **deviseの内部は「魔法」が多い**: 何が起きているか見えにくいため、問題が起きたときにデバッグが難しいことがある。ただしAI駆動開発ではClaudeが対処するため大きな問題にはならない
- **モジュールの選択は慎重に**: 不要なモジュールを有効にすると、使わないDBカラムやルーティングが増える。必要なものだけ有効にする
- **Strong Parameters**: deviseはデフォルトで `email` と `password` しか受け付けない。`username` 等の追加フィールドを許可するには、devise の `parameter_sanitizer` で設定が必要

## もっと知りたいとき

- 公式リポジトリ: https://github.com/heartcombo/devise
- 公式Wiki（設定ガイド等が充実）: https://github.com/heartcombo/devise/wiki
