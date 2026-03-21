// ユーザー情報の型定義（バックエンドのJSON表現と一致）
export interface User {
  id: number
  username: string
  email: string
  avatar_url: string | null
  bio: string | null
  created_at: string
}

// API レスポンスの型定義
export interface AuthResponse {
  user: User
}

export interface ErrorResponse {
  error?: string
  errors?: string[]
}
