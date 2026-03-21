import { Navigate } from 'react-router-dom'
import { useAuth } from '../../contexts/useAuth'

// 認証が必要なルートを保護するコンポーネント
// 未認証ユーザーはログインページにリダイレクトされる
export function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const { isAuthenticated, isLoading } = useAuth()

  if (isLoading) {
    return null
  }

  if (!isAuthenticated) {
    return <Navigate to="/login" replace />
  }

  return <>{children}</>
}
